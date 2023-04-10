# Created by: Fabert Charles
#
#
import speech_recognition as sr
import time
'''
This module is used as a control for testing the quality of different
microphones. This module outputs a file holding the response of the speech recognizer
'''
test_Counter = 0 # Increments every sentence/word the speech recognizer picks up
end_Test = 5 # How many words/sentences we want to record
f = open("response.txt", "w")  # File for holding output of recognizer

def callback(recognizer, audio):
    global test_Counter
    try:
        sentence = recognizer.recognize_google(audio, show_all=False)
        print("GOOGLE said: " + sentence)
        f.write(sentence+"\n")
        test_Counter += 1
    except:
        pass
def main():
    # Open file
    r = sr.Recognizer()
    print(sr.Microphone.list_microphone_names()) # List microphones
    m = sr.Microphone(0) # Uses built-in microphone.  Can change microphone to other found in
                         # in printed list.  Just use list index
    with m as source:
        r.adjust_for_ambient_noise(source) # Adjust for ambient sound

    stop_listening = r.listen_in_background(m, callback, phrase_time_limit=1)  # Testing sample 1s

    # Sleep main thread for one second
    while True:
        time.sleep(1)
        if test_Counter == end_Test:
            f.close()
            break
if __name__ == '__main__':
    main()
