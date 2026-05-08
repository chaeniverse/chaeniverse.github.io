---
title: "머신러닝 분류 과제 수행 단계"
date: 2024-10-24
summary: "분류(classification) ML 프로젝트의 전반적 워크플로 — 변수 탐색·결측·다중공선성·인코딩·스케일링·변수 선택부터 모델링·평가까지 단계별로 정리한 실무 가이드."
tags:
  - Machine Learning
  - Classification
  - Workflow
authors:
  - me
featured: true
---

분류(classification) 머신러닝 프로젝트를 처음부터 끝까지 끌고 가본 경험을 정리한 워크플로 가이드. **전처리 → 변수 선택 → 모델링 → 평가** 순서.

## 전처리 단계

### 1차 변수 탐색

- **범주형**: 2x2 table과 odds ratio로 변수 영향력 점검. odds ratio가 10 이상이거나 지나치게 낮으면 sensitivity/specificity 분포가 극단적으로 왜곡되므로 별도 검토.
- **연속형**: 기초 통계량 (mean, sd 등) 과 histogram으로 영향력 확인.

### 2차 변수 탐색 (결측 + 다중공선성)

**결측치 처리**

- 결측률 **40% 이상** 이면 변수의 설명력 부족으로 판단해 제거.
- 나머지는 imputation:
  - 연속형 → **median** (mean보다 극단값 영향 덜 받음)
  - 범주형 → **mode**
- Train set 통계량을 test set에도 동일 적용 (leakage 방지).

**다중공선성 (VIF)**

- Imputation 후 연속형 변수 간 VIF 산출.
- VIF $\ge 10$ 인 변수는 한 번에 한 개씩 제거하며 추이 관찰. cutoff는 주관적이지만 10 초과면 제거 권장.

### 범주형 변수 변환

- One-hot encoding은 다중공선성 우려가 있으므로, 한 카테고리를 reference로 두는 **dummy encoding** 사용.
- Reference 카테고리는 모든 컬럼에서 0인 행 → 최종 컬럼 수 = 카테고리 수 - 1.

### 정규화 / 표준화

- 연속형 변수 scale 차이가 크면 모델 설명력에 영향 → MinMaxScaler 또는 Standardization 적용.
- 표준화 통계량 (mean, sd) 역시 **train 기준으로 test에 동일 적용**.

### 변수 선택

- Feature가 많을수록 설명력은 ↑ but overfitting 위험 ↑.
- Hyperparameter 최적화 전에 변수 선택을 거친다.
- 방법: **RFE (Recursive Feature Elimination)** with **5-fold stratified CV**.
- 평가 기준: **AUROC**.
- RFE-CV 결과 그래프로 최적 feature 수 (예: 5개) 결정.

## 모델링 단계

### 데이터 분할

전체 데이터를 **3:1 stratified split** (train/test).

### 하이퍼파라미터 탐색

Train 안에서 **10-fold stratified CV**:

1. 10-fold CV로 train/val 분할
2. Train set 표준화 → 그 통계량으로 val set 표준화
3. 각 fold에서 성능 metric 계산 → 평균
4. 평균이 가장 높은 hyperparameter 조합 저장

탐색 알고리즘: **Bayesian optimization** (grid / random search보다 효율적).

### 최종 학습 + 평가

1. 전체 train data 표준화
2. 위에서 찾은 best hyperparameter로 모델 fitting → 모델 $a$
3. Train 통계량으로 test data 표준화 → 모델 $a$ 에 넣고 성능 metric 출력

### Robustness — 50회 반복

위 과정 (split → tuning → fit → test) 을 **50번 반복**하고 metric의 평균을 최종 성능으로 보고. → subject selection bias를 줄이고 robustness 확보.

## 모델 후보

- XGBoost
- Random Forest
- Support Vector Machine (SVM)
- Logistic Regression
- Multi-Layer Perceptron (MLP)

## 평가 지표

- Accuracy
- Precision
- Recall (Sensitivity)
- F1-score
- AUC-ROC

---

> 원문: <https://chaeniverse.tistory.com/81>
>
> 이 워크플로를 적용한 실제 프로젝트는 [OvaRisk-ML](/projects/ovarisk-ml/) 참고.
