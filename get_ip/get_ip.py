import requests
import os
from html.parser import HTMLParser


class Get_ip_HTMLParser(HTMLParser):
    in_ip_tag = False
    ip = ''

    def handle_starttag(self, tag, attrs):
        if tag == 'font':
            for attr in attrs:
                if attr[0] == 'color' and attr[1] == 'green':
                    self.in_ip_tag = True

    def handle_endtag(self, tag):
        pass

    def handle_data(self, data):
        if self.in_ip_tag:
            self.ip = data
            self.in_ip_tag = False


def get_ip():
    get_ip_parser = Get_ip_HTMLParser()
    url = 'http://myip.com.tw/'

    try:
        html = requests.get(url, verify=False)
    except Exception as e:
        print('No network')
        return

    get_ip_parser.feed(html.text)

    out_ip = get_ip_parser.ip
    nat_ip = os.popen('ip a | grep wlp58s0 | grep inet | awk \'{print $2}\'').read().replace('\n', '').split('/')[0]
    ssid = os.popen('iwgetid -r').read()

    if ssid != '':
        print('wifi-ssid: ' + ssid, end='')
        print('---------------------------')

    if out_ip == nat_ip:
        print('ip: ' + out_ip)
    else:
        print('out ip: ' + out_ip + '\nnat ip: ' + nat_ip)


def main():
    get_ip()


if __name__ == '__main__':
    main()
