import pandas as pd
from surprise import Dataset, Reader, KNNBasic
from flask import Flask, render_template, redirect, url_for, request
import random

app = Flask(__name__)

# 데이터 프레임을 읽어올 때 dtype 지정
ratings = pd.read_csv('ml-latest-small/ratings.csv', dtype={'userId': int, 'movieId': int, 'rating': float, 'timestamp': int})
movies = pd.read_csv('ml-latest-small/movies.csv', dtype={'movieId': int, 'title': str, 'genres': str})

reader = Reader(rating_scale=(0.5, 5.0))
data = Dataset.load_from_df(ratings[['userId', 'movieId', 'rating']], reader)
trainset = data.build_full_trainset()

sim_options = {
    'name': 'cosine',
    'user_based': True
}
algo = KNNBasic(sim_options=sim_options)
algo.fit(trainset)

@app.route('/', methods=['GET', 'POST'], endpoint='index')
def search():
    if request.method == 'POST':
        search_type = request.form.get('filter')
        query = request.form.get('query')

        if search_type == 'user':
            return redirect(url_for('user_recommendations', userId=query))
        elif search_type == 'movie':
            return redirect(url_for('movie_recommendations', movie_title=query))
        elif search_type == 'rating':
            return redirect(url_for('rating_recommendations', rating=query))

    return render_template('index.html')

@app.route('/user/<userId>')
def user_recommendations(userId):
    try:
        userId = int(userId)
        if userId not in ratings['userId'].values:
            raise ValueError("해당하는 ID가 없습니다")

        user_inner_id = algo.trainset.to_inner_uid(userId)
        neighbors = algo.get_neighbors(user_inner_id, k=10)
        neighbors_ids = [algo.trainset.to_raw_uid(inner_id) for inner_id in neighbors]

        recommended_movies = set()
        for neighbor_id in neighbors_ids:
            neighbor_ratings = ratings[ratings['userId'] == int(neighbor_id)]
            top_movies = neighbor_ratings.sort_values(by='rating', ascending=False)['movieId'].head(10).tolist()
            recommended_movies.update(top_movies)

        recommended_movies = list(recommended_movies)[:10]
        movie_titles = movies[movies['movieId'].isin(recommended_movies)]['title'].tolist()

    except ValueError:
        # If user ID not found, recommend 10 random movies
        movie_titles = movies['title'].sample(10).tolist()

    return render_template('recommendations.html', recommendations=movie_titles)

@app.route('/movie/<movie_title>')
def movie_recommendations(movie_title):
    movie_ids = movies[movies['title'].str.contains(movie_title, case=False, na=False)]['movieId']
    if not movie_ids.empty:
        movie_id = movie_ids.values[0]
        try:
            movie_inner_id = algo.trainset.to_inner_iid(movie_id)
            neighbors = algo.get_neighbors(movie_inner_id, k=10)
            neighbors_ids = [algo.trainset.to_raw_iid(inner_id) for inner_id in neighbors]
            movie_titles = movies[movies['movieId'].isin(neighbors_ids)]['title'].tolist()
        except IndexError:
            movie_titles = ["No similar movies found."]

    else:
        movie_titles = ["No similar movies found."]

    return render_template('recommendations.html', recommendations=movie_titles)

@app.route('/rating/<rating>')
def rating_recommendations(rating):
    try:
        rating = float(rating)
    except ValueError:
        rating = 3.0

    matching_movies = ratings[ratings['rating'] == rating]['movieId'].unique()
    if len(matching_movies) < 10:
        # If not enough movies with exact rating, adjust rating by ±0.5
        matching_movies = ratings[(ratings['rating'] >= rating-0.5) & (ratings['rating'] <= rating+0.5)]['movieId'].unique()

    if len(matching_movies) > 0:
        recommended_movies = random.sample(list(matching_movies), min(10, len(matching_movies)))
    else:
        recommended_movies = movies['movieId'].sample(10).tolist()

    movie_titles = movies[movies['movieId'].isin(recommended_movies)]['title'].tolist()

    return render_template('recommendations.html', recommendations=movie_titles)

if __name__ == '__main__':
    app.run(debug=True)
