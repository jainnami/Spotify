<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Spotify Song Success Prediction</title>
</head>
<body>

  <h1>🎵 Spotify Song Success Prediction</h1>
  <p><strong>STAT 4214 Final Project</strong><br>
  <strong>Team Members:</strong> Ashley Covitz, Ethan Appiah, Lidia Pinkevich, Nami Jain</p>

  <h2>📌 Overview</h2>
  <p>This project aims to predict the popularity of songs based on Spotify's top tracks of 2018 using regression and classification models. 
  By analyzing various audio features and metadata, we developed linear regression and ordinal logistic models to understand what makes a song successful on Spotify.</p>

  <h2>📂 Dataset</h2>
  <ul>
    <li><strong>Source:</strong> <a href="https://www.kaggle.com/datasets/nadintamer/top-spotify-tracks-of-2018?resource=download" target="_blank">Kaggle – Top Spotify Tracks of 2018</a></li>
    <li><strong>Observations:</strong> 100 songs</li>
    <li><strong>Variables:</strong> 13 audio and metadata features</li>
    <li><strong>Target:</strong> Rank (modeled as <code>id</code>)</li>
  </ul>

  <h2>🔍 Project Steps</h2>
  <h3>1. Data Cleaning</h3>
  <ul>
    <li>Converted <code>time_signature</code> to numeric</li>
    <li>Checked for missing values</li>
    <li>Shuffled dataset to avoid rank-order bias</li>
  </ul>

  <h3>2. Exploratory Data Analysis</h3>
  <ul>
    <li>Correlation matrix and multicollinearity heatmap</li>
    <li>Visualizations for key variables like liveness, danceability, tempo</li>
    <li>Histograms and scatterplots to explore distributions</li>
  </ul>

  <h3>3. Linear Regression Models</h3>
  <ul>
    <li>Built full model with 13 predictors</li>
    <li>Stepwise model selection using AIC and BIC</li>
    <li><strong>AIC Model:</strong> danceability, key, loudness, liveness, valence, tempo</li>
    <li><strong>BIC Model:</strong> liveness only</li>
    <li>Diagnosed multicollinearity (VIF) and outliers (Cook’s D)</li>
  </ul>

  <h3>4. Ordinal Logistic Regression</h3>
  <ul>
    <li>Grouped songs into 10 bins based on rank</li>
    <li>Fitted ordinal logistic models using full and stepwise selection</li>
    <li>Significant features: loudness, speechiness, valence</li>
  </ul>

  <h2>📊 Results</h2>
  <table border="1" cellpadding="8">
    <thead>
      <tr>
        <th>Model Type</th>
        <th>R² / AIC</th>
        <th>Significant Variables</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Linear (AIC)</td>
        <td>R² = 0.1584</td>
        <td>Danceability, Key, Loudness, Liveness, Valence, Tempo</td>
      </tr>
      <tr>
        <td>Linear (BIC)</td>
        <td>R² = 0.0644</td>
        <td>Liveness</td>
      </tr>
      <tr>
        <td>Ordinal Logistic (Full)</td>
        <td>AIC = 487.379</td>
        <td>None</td>
      </tr>
      <tr>
        <td>Ordinal Logistic (Stepwise)</td>
        <td>AIC = 478.521</td>
        <td>Loudness, Speechiness, Valence</td>
      </tr>
    </tbody>
  </table>

  <h2>⚠️ Limitations</h2>
  <ul>
    <li>Only includes top 100 songs – all are already popular</li>
    <li>Data limited to 2018 – may not generalize across years</li>
    <li>Streaming numbers influenced by artist popularity</li>
    <li>Ordinal nature of rank not fully utilized in all models</li>
  </ul>

  <h2>🔮 Future Work</h2>
  <ul>
    <li>Include less successful songs for better contrast</li>
    <li>Use more recent and diverse data across genres and years</li>
    <li>Apply more robust ordinal modeling techniques</li>
    <li>Incorporate other features (artist popularity, release date)</li>
  </ul>

  <h2>📁 Files</h2>
  <ul>
    <li><code>top2018.csv</code> – Raw Spotify dataset</li>
    <li><code>spotify_project.R</code> – Data cleaning, modeling, and plots</li>
    <li><code>Final Presentation.pdf</code> – Summary slides of findings</li>
  </ul>

  <h2>📚
