Food Recipe Nutrition Automation System
=======================================

This project is an end-to-end food analytics pipeline designed to automate the extraction, standardization, and nutritional analysis of large-scale recipe data. The system processes raw recipe content collected from food websites and YouTube channels, extracts structured ingredient and serving size information using NLP techniques, standardizes ingredient names using a machine learning model, and integrates with a nutrition API to compute complete nutritional values. The overall automation reduced manual data processing effort by approximately 70–80%.

**Business Objective**
Manual extraction and nutritional computation of recipe data is time-consuming, inconsistent, and difficult to scale. This system was built to automate recipe data collection, normalize complex culinary text, standardize ingredient names to API-supported vocabulary, compute nutritional values programmatically, and generate an analytics-ready structured dataset.

**Project Workflow**
The project follows a modular pipeline architecture:

1. Data Acquisition – Scraping recipe links, metadata, and content from multiple food platforms.
2. Text Preprocessing – Cleaning multilingual and unstructured culinary text, removing noise, and normalizing ingredient descriptions.
3. Ingredient Parsing – Extracting ingredient names and quantities using Regex-based rules and NLP logic.
4. Ingredient Standardization Model – Mapping raw ingredient names to API-approved vocabulary using SBERT embeddings and a KNN-based similarity model.
5. Nutrition API Integration – Automating REST API calls to compute macro and micro nutritional values for standardized recipes.
6. Each module is organized into separate folders for clarity and maintainability.

**Technical Stack**
1. Python (Pandas, NumPy)
2. Regex-based text processing
3. Sentence-BERT (SBERT) embeddings
4. KNN model for ingredient similarity matching
5. REST API integration
6. Modular pipeline design

**Key Achievements**
1. Processed a large-scale recipe corpus (10L+ entries).
2. Built a custom culinary text cleaning engine for structured extraction.
3. Automated ingredient normalization using machine learning techniques.
4. Integrated nutrition APIs for complete automated nutritional computation.
5. Designed a scalable, modular data pipeline for future expansion.

**Skills Demonstrated**
1. Data Cleaning & Transformation
2. NLP-Based Text Processing
3. Feature Engineering
4. Machine Learning Application
5. API Handling & Automation
6. Data Standardization
7. End-to-End Pipeline Development

**Future Enhancements**
1. Convert notebooks into production-grade Python modules.
2. Deploy the pipeline as a scalable backend service.
3. Integrate visualization dashboards for nutrition insights.
4. Improve model accuracy using advanced embedding techniques.

**Author**
Ashwani Kumar
Data Analytics | NLP | Machine Learning | Automation
