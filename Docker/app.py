from flask import Flask, render_template
import random
app = Flask(__name__)

# list of cat images
images = [
        "https://media4.giphy.com/media/3o7527pa7qs9kCG78A/giphy.gif?cid=ecf05e4702njm0wzrxvh9nmacgazwg7fgdbwn5w5a08nmotu&rid=giphy.gif&ct=g",
        "https://media1.giphy.com/media/dTJd5ygpxkzWo/200w.webp?cid=ecf05e4702njm0wzrxvh9nmacgazwg7fgdbwn5w5a08nmotu&rid=200w.webp&ct=g",
        "https://media3.giphy.com/media/Y42OeCcJI4ufXDQ3oA/giphy.webp?cid=ecf05e4702njm0wzrxvh9nmacgazwg7fgdbwn5w5a08nmotu&rid=giphy.webp&ct=g",
        "https://media4.giphy.com/media/21GCae4djDWtP5soiY/giphy.webp?cid=ecf05e4702njm0wzrxvh9nmacgazwg7fgdbwn5w5a08nmotu&rid=giphy.webp&ct=g",
        "https://media3.giphy.com/media/51Uiuy5QBZNkoF3b2Z/200w.webp?cid=ecf05e4702njm0wzrxvh9nmacgazwg7fgdbwn5w5a08nmotu&rid=200w.webp&ct=g",
        "https://media0.giphy.com/media/4Zo41lhzKt6iZ8xff9/giphy.webp?cid=ecf05e4702njm0wzrxvh9nmacgazwg7fgdbwn5w5a08nmotu&rid=giphy.webp&ct=g"
]
@app.route('/')
def index():
        url = random.choice(images)
        return render_template('index.html', url=url)

if __name__ == "__main__":
        app.run(host="0.0.0.0")
