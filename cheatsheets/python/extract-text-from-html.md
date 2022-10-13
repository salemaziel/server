# Extract text from html using Python


from urllib.request import urlopen
from bs4 import BeautifulSoup

url = "http://news.bbc.co.uk/2/hi/health/2284783.stm"
html = urlopen(url).read()
soup = BeautifulSoup(html, features="html.parser")

# kill all script and style elements
for script in soup(["script", "style"]):
    script.extract()    # rip it out

# get text
text = soup.get_text()

# break into lines and remove leading and trailing space on each
lines = (line.strip() for line in text.splitlines())
# break multi-headlines into a line each
chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
# drop blank lines
text = '\n'.join(chunk for chunk in chunks if chunk)

print(text)




This is a simple example of how to extract text from HTML in Python. This example is using a Python Library called Beautiful Soup.

BETA Snippet explanation automatically generated by OpenAI:
Here is what the above code is doing:
1.We are opening the url and reading the html file and storing it in a variable called html.
2.Then we are passing this html file to a BeautifulSoup object and specifying the html parser to use.
3.We then print the title of the webpage.