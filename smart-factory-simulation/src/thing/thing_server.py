# -*- coding: utf-8 -*-
from flask import Flask, jsonify, request, Response
import random
import json
from pathlib import Path


app = Flask(__name__)
app.json.sort_keys = False


# Lista de cores
colors = ["red", "blue", "green", "yellow", "black", "white"]

# Inicializa o valor de minimumConfidence
minimum_confidence_value = 0.75

def get_random_measure():
    color = random.choice(colors)
    confidence_measure = round(random.uniform(80, 100), 2)
    
    measure = {"color": color,
              "confidenceMeasure": confidence_measure}
    # measure = (color, confidence_measure)
    return measure

@app.route('/td', methods=['GET'])
def get_td():
    with open('td.ttl', 'r') as file:
      raw_td = file.read()
    return Response(raw_td, mimetype='text/turtle')

@app.route('/minimumConfidence', methods=['GET'])
def get_minimum_confidence():
    return jsonify(minimum_confidence_value)

@app.route('/minimumConfidence', methods=['PUT'])
def set_minimum_confidence():
    global minimum_confidence_value
    data = request.json
    if 'minimumConfidence' in data:
        minimum_confidence_value = data['minimumConfidence']
        return jsonify({"message": "minimumConfidence atualizado com sucesso!"}), 200
    return jsonify({"error": "Parâmetro 'minimumConfidence' não fornecido."}), 400

@app.route('/wheelMeasure/<id>', methods=['GET'])
def get_wheel_measure(id):
    # Escolhe pseudoaleatoriamente uma cor e um confidenceMeasure
    return jsonify(get_random_measure())

@app.route('/frontLeft', methods=['GET'])
def get_front_letf_measure():
    # Escolhe pseudoaleatoriamente uma cor e um confidenceMeasure
    return jsonify(get_random_measure())

@app.route('/frontRight', methods=['GET'])
def get_front_right_measure():
    # Escolhe pseudoaleatoriamente uma cor e um confidenceMeasure
    return jsonify(get_random_measure())

@app.route('/backLeft', methods=['GET'])
def get_back_left_measure():
    # Escolhe pseudoaleatoriamente uma cor e um confidenceMeasure
    return jsonify(get_random_measure())

@app.route('/backRight', methods=['GET'])
def get_back_right_measure():
    # Escolhe pseudoaleatoriamente uma cor e um confidenceMeasure
    return jsonify(get_random_measure())

if __name__ == '__main__':
    app.run(debug=True, port=8080)
