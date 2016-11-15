#!/bin/bash
# Author: Elias Bagley
#
# This script fetches a file in parts, and combines them at the end
###################################################################

#automatically fetch the session cookie using apple email and password
#Take the file name in on the command line
#make sure file extension can be sorted, ie out.001 instead of out.1
#cleanup the part files after a successful signature


URL="http://adcdownload.apple.com/Developer_Tools/Xcode_8.1/Xcode_8.1.xip"
HEADER_1="Accept-Encoding: gzip, deflate, sdch"
HEADER_2="Accept-Language: en-US,en;q=0.8,pt;q=0.6"
HEADER_3="Upgrade-Insecure-Requests: 1"
HEADER_4="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36"
HEADER_5="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
HEADER_7="Connection: keep-alive"

# Get the total file size
FILE_SIZE=$(curl -sI $URL -H $HEADER_1 -H $HEADER_2 -H $HEADER_3 -H $HEADER_4 -H $HEADER_5 -H 'Cookie: optimizelyEndUserId=oeu1392268078645r0.40327646979130805; optimizelySegments=%7B%7D; optimizelyBuckets=%7B%7D; ccl=oGeLFJY30CiijBIdYWY3sokaS447p0i/5Qj/wa4Au0IEsF8OJM8cRKWypulHS/5WC5P84A69FskNvHM/C/tIhZ0FOcWtM7hq2xGy72ripMZQQABKRLrOx6SYxacOGZHudXaautHywuqrmVVDn+01Skbp/bA6uzfPHBSIScylKyboAhC/ufbsbxCkrh/cIP9LFIN0k7UFocw=; geo=US; s_vnum_n2_sg=59%7C1; xp_ci=3z2B66X2z80Dz4R0z9ipz1HlijWGVy; s_ria=Flash%2021%7C; ac_history=%7B%22search%22%3A%5B%5D%2C%22kb%22%3A%5B%5B%22PH19270%22%2C%22Safari%208%20%28Yosemite%29%3A%20Automatically%20fill%20in%20forms%22%2C%22en_US%22%2C1466630003000%2C%22unknown%22%5D%2C%5B%22PH21470%22%2C%22Safari%209%20%28El%20Capitan%29%3A%20Use%20AutoFill%20to%20enter%20contact%20info%2C%20passwords%2C%20and%20more%22%2C%22en_US%22%2C1466628749000%2C%22unknown%22%5D%2C%5B%22HT202802%22%2C%22OS%20X%3A%20Using%20AppleScript%20with%20Accessibility%20and%20Security%20features%20in%20Mavericks%22%2C%22en_US%22%2C1466088071000%2C%22unknown%22%5D%2C%5B%22HT204012%22%2C%22Enabling%20and%20using%20the%20%5C%5C%5C%22root%5C%22user%20in%20OS%20X%22%2C%22en_US%22%2C1463350853000%2C%22unknown%22%5D%2C%5B%22HT204012%22%2C%22Enabling%20and%20using%20the%20%5C%5C%5C%22root%5C%22user%20in%20OS%20X%22%2C%22en_US%22%2C1463350850000%2C%22unknown%22%5D%5D%2C%22help%22%3A%5B%5D%2C%22psp%22%3A%5B%5D%2C%22offer_reason%22%3A%7B%7D%2C%22total_count%22%3A%7B%22kbs%22%3A33%2C%22last_kb%22%3A1466630003000%7D%7D; clientTimeOffsetCookie=-21600000; dssid2=937d94a5-7bae-4d73-bebb-b420b6e7c809; dssf=1; as_sfa=MnxqcHxqcHx8amFfSlB8Y29uc3VtZXJ8aW50ZXJuZXR8MHwwfDE=; s_orientationHeight=2071; s_cc=true; s_fid=359678D8DF59A86C-064B1442F7198F02; s_ppv=xcode%2520-%2520what%2527s%2520new%2520-%2520%2528english%2529; s_orientation=%5B%5BB%5D%5D; s_pathLength=developer%3D1%2C; s_invisit_n2_us=19; s_vnum_n2_us=4%7C78%2C19%7C246%2C10%7C7%2C46%7C1%2C26%7C2%2C1%7C6%2C3%7C3%2C97%7C1%2C60%7C1%2C14%7C1%2C30%7C1%2C25%7C1%2C98%7C1%2C16%7C1%2C0%7C1; s_sq=%5B%5BB%5D%5D; s_vi=[CS]v1|293A01B805149B1F-600001804005264D[CE]; ADCDownloadAuth=2nc8VGGwFLZnmItfeCncLCgShBUCd4%2FHwZdcKhoO6u3CDSCRBcfaytkpHHYmO06ti8UiqoGySCIx%0D%0AKDiyT6iGMxmv0tnSlTsahhgqWLwxholjdXUulv9o0pOFAJ3UlA4rJWlvmBYQIwdO65r7Ndlr0n3I%0D%0A5zPLur7K1lbLjwosRQHKJqn5%0D%0A' -H 'Connection: keep-alive' --compressed | grep Content-Length | awk '{print $2}' | tr -d $'\r')
echo "Total file size: $FILE_SIZE bytes"

# param order:
# $1 - filename
# $2 - lower byte range
# $3 - upper byte range (can be blank to fetch the rest of the file)
# note: repaste from curl
function fetch_part {
  curl --range $2-$3 -o $1 'http://adcdownload.apple.com/Developer_Tools/Xcode_8.1/Xcode_8.1.xip' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,pt;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cookie: optimizelyEndUserId=oeu1392268078645r0.40327646979130805; optimizelySegments=%7B%7D; optimizelyBuckets=%7B%7D; ccl=oGeLFJY30CiijBIdYWY3sokaS447p0i/5Qj/wa4Au0IEsF8OJM8cRKWypulHS/5WC5P84A69FskNvHM/C/tIhZ0FOcWtM7hq2xGy72ripMZQQABKRLrOx6SYxacOGZHudXaautHywuqrmVVDn+01Skbp/bA6uzfPHBSIScylKyboAhC/ufbsbxCkrh/cIP9LFIN0k7UFocw=; geo=US; s_vnum_n2_sg=59%7C1; xp_ci=3z2B66X2z80Dz4R0z9ipz1HlijWGVy; s_ria=Flash%2021%7C; ac_history=%7B%22search%22%3A%5B%5D%2C%22kb%22%3A%5B%5B%22PH19270%22%2C%22Safari%208%20%28Yosemite%29%3A%20Automatically%20fill%20in%20forms%22%2C%22en_US%22%2C1466630003000%2C%22unknown%22%5D%2C%5B%22PH21470%22%2C%22Safari%209%20%28El%20Capitan%29%3A%20Use%20AutoFill%20to%20enter%20contact%20info%2C%20passwords%2C%20and%20more%22%2C%22en_US%22%2C1466628749000%2C%22unknown%22%5D%2C%5B%22HT202802%22%2C%22OS%20X%3A%20Using%20AppleScript%20with%20Accessibility%20and%20Security%20features%20in%20Mavericks%22%2C%22en_US%22%2C1466088071000%2C%22unknown%22%5D%2C%5B%22HT204012%22%2C%22Enabling%20and%20using%20the%20%5C%5C%5C%22root%5C%22user%20in%20OS%20X%22%2C%22en_US%22%2C1463350853000%2C%22unknown%22%5D%2C%5B%22HT204012%22%2C%22Enabling%20and%20using%20the%20%5C%5C%5C%22root%5C%22user%20in%20OS%20X%22%2C%22en_US%22%2C1463350850000%2C%22unknown%22%5D%5D%2C%22help%22%3A%5B%5D%2C%22psp%22%3A%5B%5D%2C%22offer_reason%22%3A%7B%7D%2C%22total_count%22%3A%7B%22kbs%22%3A33%2C%22last_kb%22%3A1466630003000%7D%7D; clientTimeOffsetCookie=-21600000; dssid2=937d94a5-7bae-4d73-bebb-b420b6e7c809; dssf=1; as_sfa=MnxqcHxqcHx8amFfSlB8Y29uc3VtZXJ8aW50ZXJuZXR8MHwwfDE=; s_orientationHeight=2071; s_cc=true; s_fid=359678D8DF59A86C-064B1442F7198F02; s_ppv=xcode%2520-%2520what%2527s%2520new%2520-%2520%2528english%2529; s_orientation=%5B%5BB%5D%5D; s_vnum_n2_us=4%7C78%2C19%7C246%2C10%7C7%2C46%7C1%2C26%7C2%2C1%7C6%2C3%7C3%2C97%7C1%2C60%7C1%2C14%7C1%2C30%7C1%2C25%7C1%2C98%7C1%2C16%7C1%2C0%7C1; s_sq=%5B%5BB%5D%5D; s_vi=[CS]v1|293A01B805149B1F-600001804005264D[CE]; ADCDownloadAuth=qVTTJWC1o%2F5Ov6zrEnSCKJl3ika1CeS3EUomcP277SPidIRH4DblvgKJWzpf7ki1EjH8EtoVYfyA%0D%0AEYAPCk97b8ygQIEZXpWzWkDelyFgBnGhGUwskM%2Fbpsw2VvT1e%2B%2FWGqKFaiGdI5AiEANuqN0GsKjN%0D%0AyOCuHQmUCMUXLjcB0eD8o%2BJg%0D%0A' -H 'Connection: keep-alive' --compressed
}

PART_SIZE=20000000 # size in bytes to download for each part

OUTPUT_FILENAME=$(basename $URL)
COUNT=0
LOWER_RANGE=0
UPPER_RANGE=$(($PART_SIZE-1))
PART_FILE=out.$COUNT
NUM_PARTS=$((FILE_SIZE/PART_SIZE))

# increments the global count variables for the main loop
function increment_count {
  COUNT=$(($COUNT+1))
  LOWER_RANGE=$(($LOWER_RANGE+$PART_SIZE))
  UPPER_RANGE=$(($UPPER_RANGE+$PART_SIZE))
  PART_FILE=out.$COUNT
}

# returns the file size in bytes of the first argument
function file_size {
  ls -l $1 | awk '{print $5}'
}

# loop as long as the upper range is less than the total
while [ $UPPER_RANGE -lt $FILE_SIZE ]
do
  echo "Fetching part $COUNT of $NUM_PARTS"

  # check to see if the part already exists - if so we can skip it
  if [ -f $PART_FILE ]; then
    # check to see if it has the full size
    SIZE=$(file_size $PART_FILE)
    echo "Part size: $SIZE"

    if [ $SIZE -lt $PART_SIZE ]; then
      # rm this file so it can be fully refetched
      rm $PART_FILE
      echo "Refetching $PART_FILE..."
    else
      echo "Part $COUNT already exist"
      increment_count
      continue
    fi

  fi

  #otherwise, fetch the part
  fetch_part $PART_FILE $LOWER_RANGE $UPPER_RANGE

  # update for next loop
  increment_count
done

#download the remainder till the end of the file
fetch_part $PART_FILE $LOWER_RANGE

#combine back into single file, by reverse time of creation
echo "Combining output..."
ls -1tr out.* | while read fn ; do cat "$fn" >> $OUTPUT_FILENAME; done

COMBINED_SIZE=$(file_size $OUTPUT_FILENAME)
if [ $COMBINED_SIZE -ne $FILE_SIZE ]; then
  echo "File sizes don't match! Something went wrong"
else
  echo "File sizes match!"
fi

# Check the signature of the xip archive
pkgutil --check-signature $OUTPUT_FILENAME
