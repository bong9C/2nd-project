from flask import Flask, request, render_template

app = Flask(__name__)


@app.route('/post', methods=['GET', 'POST'])
def post():
    if request.method == 'POST':
        value = request.form['id_name']
        value = str(value)
        print(value)
    return render_template('post.html')


# @app.route('/tmp', methods=['GET', 'POST'])
# def tmp():
#     value = 'hello, world'
#     return render_template('tmp.html', value=value)


if __name__ == '__main__':
    app.run()


# @app.route('/post', methods=['GET', 'POST'])
# def post():
#     if request.method == 'POST':
#         value = request.form['id_name']
#         value = str(value)
#         print(value)
#     return render_template('post.html')
