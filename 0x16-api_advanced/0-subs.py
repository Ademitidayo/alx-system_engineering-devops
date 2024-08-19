#!/usr/bin/python3
"""
Script that queries subscribers on a given Reddit subreddit.
"""

import requests

def number_of_subscribers(subreddit):
    """return number of total subscribers ona subreddit and 0 if invalid"""
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {'User-Agent': 'MyAPI/0.0.1'}
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        return 0
    else:
        data = response.json()
        subscribers = data['data']['subscribers']
        return subscribers
