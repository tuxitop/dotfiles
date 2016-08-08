# -*- coding: utf-8 -*-

"""
Display PACKT's free book offer.

The PACKT publishing is offering free books every day, this module checks it's
website everyday for and displays the book title.

Configuration parameters:
    - cache_timeout : how often we refresh this module in seconds
    - regex : the regular expression used to find the book title
    - packt_url: the url of offers.
@author Ali Mousavi ali.mousavi@gmail.com
@license BSD
"""

# import your useful libs here
from time import time
import re
import urllib.request


class Py3status:
    """
    """
    # available configuration parameters

    # update every 6 hours
    cache_timeout = 21600
    packt_url = "https://www.packtpub.com/packt/offers/free-learning"
    regex = '<h2>\\n(\\t)*(.*?)(\\t)*</h2>'

    def __init__(self):
        """
        This is the class constructor which will be executed once.
        """
        pass

    def packt_get(self, i3s_output_list, i3s_config):
        """
        """
        try:
            page = urllib.request.urlopen(self.packt_url)
            page_text = page.read()
            matched = re.search(self.regex, page_text.decode("utf-8"))
            book_title = matched.group(2)
        except Exception as e:
            book_title = str(e.reason)

        response = {
            'cached_until': time() + self.cache_timeout,
            'full_text': "PACKT: " + book_title
        }
        return response

if __name__ == "__main__":
    """
    Test this module by calling it directly.
    This SHOULD work before contributing your module please.
    """
    from time import sleep
    x = Py3status()
    config = {
        'color_bad': '#FF0000',
        'color_degraded': '#FFFF00',
        'color_good': '#00FF00'
    }
    while True:
        print(x.packt_get([], config))
        sleep(1)
