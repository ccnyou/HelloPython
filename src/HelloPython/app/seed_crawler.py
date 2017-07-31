# -*- coding: utf-8 -*-
import urllib.request
import urllib.error
import urllib.parse
import os
import configparser
import sys
import lxml
from bs4 import BeautifulSoup


g_default_config_file = "seed_crawler.conf"


class SeedConfig:
    def __init__(self):
        self.url = ""
        self.title_file_name = ""
        self.seed_file_name = ""
        self.base_url = ""
        self.output_dir = ""
        self.title_file_path = ""
        self.seed_file_path = ""

    @staticmethod
    def load(file_name):
        config = configparser.ConfigParser()
        config.read(file_name)

        self = SeedConfig()
        self.url = config.get("in", "url")
        self.seed_file_name = config.get("out", "seed")
        self.title_file_name = config.get("out", "title")
        self.output_dir = config.get("out", "output")
        url_parse = urllib.parse.urlparse(self.url)
        self.base_url = url_parse.scheme + "://" + url_parse.netloc

        self.seed_file_path = os.path.join(self.output_dir, self.seed_file_name)
        self.title_file_path = os.path.join(self.output_dir, self.title_file_name)

        return self


def load_html(url):
    page = urllib.request.urlopen(url)
    html = page.read()
    return html


def parse_seed_link(soup):
    nodes = soup.find_all("div", class_="n_bd")
    if len(nodes) <= 0:
        return ""
    div = nodes[0]
    text = div.text
    begin = text.find("magnet")
    if begin < 0:
        return ""
    end = text.find(" ", begin)
    seed_link = text[begin:end]
    seed_link = seed_link.encode("utf-8")
    index = seed_link.find("\n".encode("utf-8"))
    if index > 0:
        seed_link = seed_link[0:index]
    return seed_link


def parse_seed_title(soup):
    nodes = soup.find_all("div", class_="index_box")
    if len(nodes) <= 0:
        return ""
    div = nodes[0]
    nodes = div.find_all("h2")
    if len(nodes) <= 0:
        return ""
    h2 = nodes[0]
    text = h2.text
    text = text.encode("utf-8")
    return text


def craw_page(url, seed_file_path, title_file_path):
    html = load_html(url)
    soup = BeautifulSoup(html, "html.parser")
    seed_link = parse_seed_link(soup)
    seed_title = parse_seed_title(soup)
    if len(seed_link) <= 0 or len(seed_title) <= 0:
        print("error, url = " + url)
        return
    seed_link += "\n".encode("utf-8")
    seed_title += "\n".encode("utf-8")
    with open(seed_file_path, "ab+") as f:
        f.write(seed_link)
    with open(title_file_path, "ab+") as f:
        f.write(seed_title)


def init_output_files(config):
    if not os.path.exists(config.output_dir):
        os.mkdir(config.output_dir)
    if os.path.exists(config.seed_file_path):
        os.remove(config.seed_file_path)
    if os.path.exists(config.title_file_path):
        os.remove(config.title_file_path)


def parse_topic_nodes(url):
    html = load_html(url)
    soup = BeautifulSoup(html, "html.parser")
    nodes = soup.find_all("div", class_="zxlist")
    if len(nodes) <= 0:
        return []
    node = nodes[0]
    nodes = node.find_all("a")
    return nodes


def main():
    config = load_seed_config()
    init_output_files(config)
    nodes = parse_topic_nodes(config.url)
    count = len(nodes)
    if count <= 0:
        return
    print("%d topic found" % count)
    for i, node in enumerate(nodes):
        print("crawling %d topic" % (i + 1))
        href = node.get("href")
        page_url = config.base_url + href
        craw_page(page_url, config.seed_file_path, config.title_file_path)


def load_seed_config():
    config_file_name = g_default_config_file
    if len(sys.argv) == 2:
        config_file_name = sys.argv[1]
    config = SeedConfig.load(config_file_name)
    return config


if __name__ == '__main__':
    main()
