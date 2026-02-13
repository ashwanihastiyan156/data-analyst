ESG Document Classification using BERT
======================================

**Project Overview**
This project implements an ESG (Environmental, Social, Governance) document classifier using a fine-tuned BERT (bert-base-uncased) model. The system classifies individual pages of corporate PDF reports into Environmental, Social, or Governance categories and also generates document-level ESG summaries. The objective is to automate ESG content identification and improve semantic understanding of corporate disclosures using transformer-based NLP.

**Objectives**
1. Automate ESG classification of corporate report pages
2. Compare classical ML baseline (TF-IDF + Logistic Regression) with BERT
3. Improve macro F1-score using contextual embeddings
4. Provide both page-level and document-level ESG insights

**Model Architecture**

-Base Model: bert-base-uncased
-Task: 3-class multi-class classification (E, S, G)
-Loss Function: Cross-Entropy Loss
-Optimizer: AdamW (via Hugging Face Trainer)
-Epochs: 3
-Batch Size: 8
-Evaluation: Per epoch

**Dataset**
1. Input: Corporate ESG PDF reports
2. Labels: Provided in labels.xlsx
3. Each labeled row corresponds to a specific PDF page
4. Classes:
  E → Environmental
  S → Social
  G → Governance
Note: Complete dataset not included due to size constraints (sample data included).

**Project Pipeline**
1. Load labeled data
2. Parse PDF names and page numbers
3. Extract page text using PyMuPDF
4. Clean and preprocess text
5. Perform stratified train-test split
6. Tokenize using BERT tokenizer
7. Fine-tune BERT for classification
8. Evaluate using accuracy, precision, recall, and macro F1-score
9. Generate page-level and document-level predictions

**Features**
1. Page-Level ESG Prediction: The model predicts ESG class for a specific page of a PDF report.
2. Full PDF Classification: Classifies all valid pages in a report and returns structured predictions including page numbers and ESG labels.
3. Document-Level ESG Summary: Computes percentage distribution of Environmental, Social, and Governance content within a report.

**Evaluation Metrics**
1. Accuracy
2. Precision
3. Recall
4. Macro F1-Score
5. Normalized Confusion Matrix

The BERT-based model demonstrated improved macro F1-score and better semantic understanding compared to the TF-IDF + Logistic Regression baseline.

**Model Saving**
The fine-tuned model and tokenizer are saved using Hugging Face save_pretrained method, enabling reusable inference without retraining.
Note: Model not included due to size restrictions.

**Hardware**
Training accelerated using NVIDIA RTX 3050 GPU with CUDA-enabled PyTorch.

**Technologies Used**
1. Python
2. PyTorch
3. Hugging Face Transformers
4. Scikit-learn
5. PyMuPDF
6. Pandas
7. Seaborn

**Future Improvements**
1. Hyperparameter tuning
2. Domain-adaptive pretraining on ESG corpus
3. DistilBERT for faster inference
4. REST API deployment using FastAPI
5. Streamlit dashboard for ESG visualization

**Author**
Ashwani Kumar
Data Analyst
