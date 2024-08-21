#!/usr/bin/python3
'''
    this module contains the function top_ten
'''
import requests
from sys import argv

def top_ten(subreddit):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {'User-Agent': 'MyAPI/0.0.1'}
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        print("None")
        return

    data = response.json()
    posts = data.get('data', {}).get('children', [])

    for post in posts:
        print(post.get('data', {}).get('title'))
