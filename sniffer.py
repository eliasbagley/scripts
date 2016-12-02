# This frida script sniffs the signing key used for signing private API requests
# Last tested on Instagram 9.6.0
# To use - insteall frida-server on a rooted device, and run:
# > python sniffer.py
#
# Play around with the android app until a signed request is issued, such as when following another user
################################################################################################
import frida, sys

def on_message(message, data):
    print(message)

process = frida.get_usb_device().attach('com.instagram.android')

jscode = """
Interceptor.attach(Module.findExportByName("libscrambler.so", "_ZN9Scrambler9getStringESs"), {
    onLeave: function (retval) {
        console.log(Memory.readCString(retval));
    }
});
"""

script = process.create_script(jscode)
script.on('message', on_message)
print('[*] Running sniffer')
script.load()
sys.stdin.read()
