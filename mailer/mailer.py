#! /usr/bin/python2.7
#coding=UTF-8

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from subprocess import Popen, PIPE
import time
from optparse import OptionParser
import smtplib


def banner():
    print("                 _ _             "
        "\n                (_) |            "
        "\n _ __ ___   __ _ _| | ___ _ __   "
        "\n| '_ ` _ \ / _` | | |/ _ \ '__| "
        "\n| | | | | | (_| | | |  __/ |    "
        "\n|_| |_| |_|\__,_|_|_|\___|_|    "
        " \n                       v 0.2    "
          "\n")


def main():

    usage = "usage: mailer.py <emails.txt> <text.txt>"
    parser = OptionParser(usage)
    parser.add_option("-i", "--interactive", dest="interactive", help='interactive mode',
                      action="store_true" )
    parser.add_option("-f", "--from", help="""sender email in quotes 'ivan ivanov <ivanov@mail.com>'"""
                      , dest="sender_email")
    parser.add_option("-s", "--subject", help="subject of the email", dest ="subject")
    parser.add_option("-p", "--plaintext", help="plaintext body of the email", dest="plaintext")
    (options, args) = parser.parse_args()
    if options.interactive:
        interactive()
    if len(args) < 2:
        parser.error("incorrect number of arguments")
    try :
        file_emails = open(args[0],'r')
        file_text = (open(args[1],'r'))
    except:
        print ('ERROR! There is no such files')
        exit()
    sender = 'Test sender <test@mail.com>'
    if options.sender_email:
        sender = options.sender_email
    subject = 'Test subject'
    if options.subject:
        subject = options.subject
    plaintext = 'Put your text here'
    if options.plaintext:
        plaintext = options.plaintext
    for line in file_emails:

        sendmail(sender,line.strip(),plaintext,file_text.read(),subject)

        time.sleep(5)



def sendmail(sender,mail,plaintext,htmltext,subject):

    msg = MIMEMultipart("alternative")
    msg["From"] = sender
    msg["To"] = mail
    msg['MIME-Version']="1.0"
    msg['Subject'] = subject
    msg['Content-Type'] = "text/html; charset=utf-8"
    msg['Content-Transfer-Encoding'] = "quoted-printable"

    part1 = MIMEText(plaintext, 'plain')
    part2 = MIMEText(htmltext, 'html')
    msg.attach(part1)
    msg.attach(part2)

    p = Popen(["/usr/sbin/sendmail", "-t"], stdin=PIPE)
    p.communicate(msg.as_string())



def interactive():
    choice = raw_input('Type (1) or List (2): ')
    choice = int(choice)


    if choice == 1:
        ask = raw_input('Use SMTP relay? y/n: ')
        ask = str(ask)
        if ask == 'y':
            SERVER = raw_input("SMTP relay adress: ")
            PORT = raw_input("SMTP relay port (default: 25): ")
            mailList = raw_input("Enter recipient address: ")
            sender = raw_input("From: ")
            subject = raw_input("Subject: ")
            plaintext = raw_input("Plaintext: ")
            htmls = raw_input("Enter name of html file: ")
            htmltext = open(htmls, "r")
            server = smtplib.SMTP(SERVER,PORT)
            server.helo('ooo')
            server.sendmail(sender,mailList,plaintext,htmltext.read(),subject)
            print "Done! Sent via " + SERVER + " relay."
            exit()
        elif ask == 'n':
            mailList = raw_input("Enter recipient address: ")
            sender = raw_input("From: ")
            subject = raw_input("Subject: ")
            plaintext = raw_input("Plaintext: ")
            htmls = raw_input("Enter name of html file: ")
            htmltext = open(htmls, "r")
            sendmail(sender,mailList,plaintext,htmltext.read(),subject)
            print "Done!"
            exit()

    elif choice == 2:
        ask = raw_input('Use SMTP relay? y/n: ')
        ask = str(ask)
        if ask == 'y':
            SERVER = raw_input("SMTP relay adress: ")
            PORT = raw_input("SMTP relay port (default: 25): ")
            emailfile = raw_input('Adresses file name: ')
            urlFile = open(emailfile, "r")
            mailList = [i.strip() for i in urlFile.readlines()]
            sender = raw_input("From: ")
            subject = raw_input("Subject: ")
            plaintext = raw_input("Plaintext: ")
            htmls = raw_input("Enter name of html file: ")
            htmltext = open(htmls, "r").read()
            sleep_time = raw_input("Sleep time in seconds: ")
            sleep = int(sleep_time)
            server = smtplib.SMTP(SERVER,PORT)
            server.helo('ooo')
            for mail in mailList:
                    print 'Processing...'
                    server.sendmail(sender,mail,plaintext,htmltext,subject)
                    print 'Sended via ' + SERVER + ' Sleep ' + sleep_time + 's'
                    time.sleep(sleep)
            print "Exiting.."
            exit()
        elif ask == 'n':
            emailfile = raw_input('Adresses file name: ')
            urlFile = open(emailfile, "r")
            mailList = [i.strip() for i in urlFile.readlines()]
            sender = raw_input("From: ")
            subject = raw_input("Subject: ")
            plaintext = raw_input("Plaintext: ")
            htmls = raw_input("Enter name of html file: ")
            htmltext = open(htmls, "r").read()
            sleep_time = raw_input("Sleep time in seconds: ")
            sleep = int(sleep_time)
            for mail in mailList:
                    print 'Processing...'
                    sendmail(sender,mail,plaintext,htmltext,subject)
                    print 'Sended! Sleep ' + sleep_time + 's'
                    time.sleep(sleep)
            print "Exiting.."
            exit()




if __name__ == "__main__":
    banner()
    main()
