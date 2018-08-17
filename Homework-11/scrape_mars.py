# Dependencies
from bs4 import BeautifulSoup as bs
import pandas as pd
from splinter import Browser
import time

def scrape():
    # Setup the browser for scraping
    executable_path = {'executable_path': '/usr/local/bin/chromedriver'}
    browser = Browser('chrome', **executable_path, headless=False)

    # Get the latest Mars news
    url = 'https://mars.nasa.gov/news/'
    browser.visit(url)
    time.sleep(5)
    html = browser.html
    soup = bs(html, 'lxml')
    result = soup.find('div', class_='list_text')
    
    news = result.find('div', class_='content_title')
    news_title = news.a.text
    news_desc = result.find('div', class_='article_teaser_body').text
        
    #print("Title: " + news_title)
    #print("Description: " + news_desc)

    # Get the JPL Mars Space Featured Image
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)

    html = browser.html
    soup = bs(html, 'lxml')

    featured_image_url = ""
    featured_image_title = ""

    articles = soup.find_all('article', class_='carousel_item')

    for article in articles:
        link = article.find('a')
        href = link['data-fancybox-href']
        featured_image_url = 'https://www.jpl.nasa.gov/' + href
        featured_image_title = link['data-title']

    #    print(featured_image_title)
    #    print(featured_image_url)

    # Get the latest Mars Weather Report from twitter
    mars_weather = ""
    url = "https://twitter.com/marswxreport?lang=en"
    browser.visit(url)

    html = browser.html
    soup = bs(html, "lxml")

    tweets = soup.find_all('p', class_='tweet-text')

    for tweet in tweets:
        tweettext = tweet.text
        if ("Sol " in tweettext):
            mars_weather = tweettext
            break
            
    #print(mars_weather)

    # Get some Mars Facts
    url = "http://space-facts.com/mars"

    tables = pd.read_html(url)
    df = tables[0]
    df.columns = ['description','value']

    # Covert Mars Facts to an HTML table string
    df.set_index('description', inplace=True)
    mars_facts_table = df.to_html(justify='left', classes='text-nowrap')
    mars_facts_table = mars_facts_table.replace("\n","")
    #print(mars_facts_table)

    # Collecting Mars Hemisphere Links
    url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(url)

    html = browser.html
    soup = bs(html, 'lxml')

    links = soup.find_all('a', class_='itemLink product-item')
    hemisphere_image_urls = []

    for link in links:
        href = link['href']
        product_url = 'https://astrogeology.usgs.gov' + href
        title = link.find('h3')
        if (title):
            browser.visit(product_url)
            html = browser.html
            soup = bs(html, "lxml")
            img = soup.find('img', class_='wide-image')
            img_url = 'https://astrogeology.usgs.gov' + img.get('src')
            hemisphere_image_urls.append({'title': title.text, 'img_url': img_url})

    #print(hemisphere_image_urls)

    # Save all scraped data to one dictionary
    mars = {'news_title': news_title, 'news_desc': news_desc, 'featured_image_title': featured_image_title, \
            'featured_image_url': featured_image_url, 'mars_weather': mars_weather, 'mars_facts_table': mars_facts_table, \
            'hemisphere_image_urls': hemisphere_image_urls}

    #print(mars)
    return mars



