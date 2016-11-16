#!/bin/sh
#
# This script bumps the version in the podspec, and tags commits and publishes
# This script requires podspec-bump package. run: npm install -g podspec-bump
#
# Usage:
# ./release-pod -1 to bump the major version
# ./release-pod -2 to bump the minor version
# ./release-pod -3 to bump the patch version
#
# Note: this script takes a long time to run, since linting takes a long time
#
##########################################################################################

POD_REPO_SOURCE_URL=""
POD_REPO_NAME=""


##########################################################################################
# Functions
##########################################################################################

# Evals a function and exits the script if any error occured
function run() {
  cmd_output=$(eval $1)
  return_value=$?
  if [ $return_value != 0 ]; then
    echo "Command $1 failed"
    exit -1
  fi
  return $return_value
}

##########################################################################################
# Parse command-line options
##########################################################################################

OPTION=patch #default no arguments to bumping the patch version

args=`getopt 123 $*`
if [ $? != 0 ]
then
       echo 'Usage: ./release-pod -1 for bumping major version, ./release-pod -2 for minor, ./release-pod -3 for patch'
       exit 2
fi

set -- $args

for i
do
       case "$i"
       in
               -1)
                       OPTION=major
                       shift;;
               -2)
                       OPTION=minor
                       shift;;
               -3)
                       OPTION=patch
                       shift;;
               --)
                       shift; break;;
       esac
done

##########################################################################################

# Checkout dev and make sure it's up to date
run "git checkout dev"
run "git pull"

# Run the teststests
#echo "Running tests..."
#run "xcodebuild test -workspace SudoUIKit.xcworkspace -scheme SudoUIKitTests -destination 'platform=iOS Simulator,name=iPhone 6s'"

# Note: This has been disabled for now since linting takes 15+ minutes, and the repo will lint the pod when doing a pod repo push and will reject the push if it doesn't lint
# Lint the repo
echo "Linting... This might take a couple of minutes"
run "pod lib lint --private --allow-warnings --sources='$POD_REPO_SOURCE_URL,https://github.com/CocoaPods/Specs.git' --fail-fast"

# Bump version
run "podspec-bump $OPTION -w"
VERSION=`podspec-bump --dump-version`
echo "Bumped podspec version to $VERSION"

# Commit
run "git commit -am 'Bump podspec version to $VERSION'"

# Checkout new branch for this version (required for publishing the pod)
run "git checkout -b v$VERSION"

# Push the new branch
run "git push -u origin v$VERSION"

# Publish
echo "Publishing to pod repository... This might take a couple of minutes"
run "pod repo push $POD_REPO_NAME --private --allow-warnings"

# Do all the pushes last
run "git checkout dev"
run "git push"

# Merge into master
run "git checkout master"
run "git pull"
run "git merge dev --no-edit"

# Tag & push master
run "git tag v$VERSION"
run "git push"
run "git push --tags"
