---
title: "가능도비 검정 (Likelihood Ratio Test)"
date: 2023-01-17
summary: "귀무가설 vs 대립가설 영역 각각에서 가능도함수의 최댓값 비를 검정 통계량으로 쓰는 LRT. 정의·기각역의 의미·정규모형 평균 검정 예제(결국 t-검정으로 귀결되는 과정)까지 정리."
tags:
  - Statistics
  - Hypothesis Testing
  - Likelihood Ratio Test
  - MLE
authors:
  - me
featured: true
---

## LR 검정 (Likelihood Ratio Test)

간단히 말하면, **자료가 귀무가설보다 대립가설의 영역에서 나왔을 가능성**을 비교하는 검정이다.

검정 통계량은

$$\lambda \;=\; \frac{L(\hat{\Omega}_0)}{L(\hat{\Omega})} \;=\; \frac{\displaystyle \max_{\theta \in \Omega_0} L(\theta)}{\displaystyle \max_{\theta \in \Omega} L(\theta)}$$

즉 **(H₀ 하에서 가능도함수의 max) ÷ (전체 모수공간에서 가능도함수의 max)** 이다.

분자가 분모의 일부이므로 항상 $0 < \lambda \le 1$ 이고, 이를 다시 쓰면

$$\lambda \;=\; \frac{L(\hat{\Omega}_0)}{\max\{L(\hat{\Omega}_0),\, L(\hat{\Omega}_1)\}} \;=\; \frac{1}{\max\Big\{1,\; \dfrac{L(\hat{\Omega}_1)}{L(\hat{\Omega}_0)}\Big\}}$$

## 기각역의 의미

LRT의 기각역은 $\lambda \le \lambda_0$ 형태인데, 위 식을 뒤집으면 결국

$$\frac{L(\hat{\Omega}_1)}{L(\hat{\Omega}_0)} \;\ge\; c$$

인 영역이다. 이 영역에서는 자료가 H₀ 보다 H₁ 에서 나왔을 가능성이 더 높다는 뜻이므로, **H₀를 기각하는 게 타당하다**.

## 예제: 정규모형의 평균 검정

$X_1, \dots, X_n \sim N(\mu, \sigma^2)$ 일 때,

$$H_0:\ \mu = 0,\ \sigma^2 > 0 \quad \text{vs.} \quad H_1:\ \mu \neq 0,\ \sigma^2 > 0$$

에 대한 크기 $\alpha$ 의 LRT를 유도해보자.

### 1) MLE 계산

**전체 모수공간** $\Omega$ 에서 MLE는

$$\hat{\mu} = \bar{x}, \qquad \hat{\sigma}^2 = \frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})^2$$

따라서

$$L(\hat{\Omega}) = (2\pi\hat{\sigma}^2)^{-n/2} \exp(-n/2)$$

**Under $H_0$** 에서는 $\mu = 0$ 으로 강제되므로

$$\hat{\mu}_0 = 0, \qquad \hat{\sigma}^2_0 = \frac{1}{n}\sum_{i=1}^n x_i^2$$

따라서

$$L(\hat{\Omega}_0) = (2\pi\hat{\sigma}^2_0)^{-n/2} \exp(-n/2)$$

### 2) $\lambda$ 단순화

$$\lambda = \frac{L(\hat{\Omega}_0)}{L(\hat{\Omega})}
= \frac{(2\pi\hat{\sigma}^2_0)^{-n/2}\,\exp(-n/2)}{(2\pi\hat{\sigma}^2)^{-n/2}\,\exp(-n/2)}
= \left(\frac{\hat{\sigma}^2_0}{\hat{\sigma}^2}\right)^{-n/2}$$

기각 조건 $\lambda \le \lambda_0$ ($0 < \lambda_0 < 1$)는

$$\left(\frac{\hat{\sigma}^2_0}{\hat{\sigma}^2}\right)^{-n/2} \le \lambda_0
\quad\Longleftrightarrow\quad \frac{\hat{\sigma}^2_0}{\hat{\sigma}^2} \ge k$$

### 3) $\hat{\sigma}^2_0$ 와 $\hat{\sigma}^2$ 의 관계

$\sum x_i^2 = \sum (x_i - \bar{x})^2 + n\bar{x}^2$ 항등식을 쓰면

$$n\hat{\sigma}^2_0 = \sum x_i^2 = \sum(x_i - \bar{x})^2 + n\bar{x}^2 = n\hat{\sigma}^2 + n\bar{x}^2$$

따라서

$$\hat{\sigma}^2_0 = \hat{\sigma}^2 + \bar{x}^2$$

### 4) t-통계량 형태로 변환

$\hat{\sigma}^2_0 / \hat{\sigma}^2 \ge k$ 에 대입하면

$$\frac{\hat{\sigma}^2 + \bar{x}^2}{\hat{\sigma}^2} = 1 + \frac{\bar{x}^2}{\hat{\sigma}^2} \;\ge\; k
\quad\Longleftrightarrow\quad \frac{\bar{x}^2}{\hat{\sigma}^2} \;\ge\; k - 1
\quad\Longleftrightarrow\quad \frac{|\bar{x}|}{\hat{\sigma}} \;\ge\; k_2$$

이제 표본분산 $s^2 = \dfrac{1}{n-1}\sum (x_i - \bar{x})^2$ 와의 관계를 쓰면

$$n\hat{\sigma}^2 = (n-1)s^2 \quad\Longrightarrow\quad \hat{\sigma} = s\sqrt{\frac{n-1}{n}}$$

이를 대입해 정리하면 결국

$$\left|\frac{\bar{x}}{s/\sqrt{n}}\right| \;\ge\; c$$

즉 t-통계량의 절댓값이 어떤 임계값 $c$ 이상인 영역이 기각역이다.

### 5) 크기 $\alpha$ 조건으로 $c$ 결정

$$\alpha = \max_{\Omega_0} P\!\left(\left|\frac{\bar{x}}{s/\sqrt{n}}\right| \ge c\right)
       = P\!\left(\left|\frac{\bar{x}}{s/\sqrt{n}}\right| \ge c \;\Big|\; \mu = 0\right)
       = P\big(|t| \ge c\big), \quad t \sim t(n-1)$$

이로부터

$$c = t_{\alpha/2}(n-1)$$

### 6) 결론

크기 $\alpha$ LRT의 검정 기각역은

$$C = \left\{(x_1, \dots, x_n) \;\Big|\; \left|\frac{\bar{x}}{s/\sqrt{n}}\right| \ge t_{\alpha/2}(n-1)\right\}$$

→ 익숙한 **단일표본 양측 t-검정**과 정확히 같다. 즉 정규모형 평균에 대한 LRT는 t-검정으로 자연스럽게 환원된다.

---

> 원문: <https://chaeniverse.tistory.com/10>
