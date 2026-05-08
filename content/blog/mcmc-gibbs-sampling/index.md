---
title: "MCMC (Gibbs Sampling)"
date: 2023-12-18
summary: "베이지안 추론에서 사후 분포가 닫힌 형태로 구해지지 않을 때 쓰는 Gibbs sampling을, 정규-역감마 모형 예제로 차근차근 유도하고 알고리즘으로 정리한 노트."
tags:
  - Statistics
  - Bayesian
  - MCMC
  - Gibbs Sampling
authors:
  - me
featured: true
---

## Bayes' Theorem 기초

$$P(a|b) = \frac{P(a \cap b)}{P(b)}$$

$$P(b|a) = \frac{P(a \cap b)}{P(a)}$$

$$P(a \cap b) = P(a)P(b|a)$$

$$P(a|b) = \frac{P(a)P(b|a)}{P(b)} \quad (\text{where } P(b) \text{ is constant})$$

$$P(a|b) \propto P(a)P(b|a) \quad (\text{using } \pi \text{ instead of } P)$$

$$\pi(a|b) \propto \pi(a)\pi(b|a) \quad (\text{*이 식 알아두면 유용하다})$$

## When to Use Gibbs Sampling

그럼 이 Gibbs sampling이라는 게 언제 사용하는 건지 알아보자.

$$y_i|\mu,\sigma^2 \sim N(\mu,\sigma^2), \quad i=1,\dots,n$$

위의 분포에서 $\mu, \sigma^2$ 는 unknown parameter이고,

- frequentist 관점에서는 $\mu, \sigma^2$ 를 MLE로 고정시킨다.
- 반면 베이지안들은 이 unknown parameter에 분포를 걸어놓고 생각한다.

이때 사용하는 게 Gibbs sampling이다.

## Posterior Distribution

이 unknown parameter의 분포를 구하기 위해서는 다음과 같은 과정이 필요하다.

$$y_i|\mu,\sigma^2 \sim N(\mu,\sigma^2), \quad i=1,\dots,n$$

$$P(\mu,\sigma^2|y_1,\dots,y_n) \propto P(y_1,\dots,y_n|\mu,\sigma^2)P(\mu,\sigma^2)$$

$$P(\mu,\sigma^2|y_1,\dots,y_n) \propto P(y_1,\dots,y_n|\mu,\sigma^2)P(\mu)P(\sigma^2) \quad (\mu \perp \sigma^2)$$

$$\propto P(y_1,\dots,y_n|\mu,\sigma^2)P(\mu) \quad (P(\sigma^2) \text{ known이므로 constant 취급})$$

이때 $P(\mu,\sigma^2|y_1,\dots,y_n)$ 는 posterior, $P(y_1,\dots,y_n|\mu,\sigma^2)$ 는 likelihood, $P(\mu)$ 는 prior 가 된다.

여기서 보통 $P(\mu) \sim N(\mu_0, \sigma^2_0)$, $P(\sigma^2) \sim IG(a,b)$ 로 둔다. $\mu_0, \sigma^2_0, a, b$ 는 hyperparameter이고 내가 정하는 것이므로 prior라고 한다.

## $\mu$ 의 조건부 분포 유도

$$P(y_1,\dots,y_n|\mu,\sigma^2)P(\mu)$$

$$= \left(\frac{1}{\sqrt{2\pi\sigma^2}}\right)^n\prod_{i=1}^{n}\exp\left(-\frac{1}{2\sigma^2}(y_i-\mu)^2\right) \times \frac{1}{\sqrt{2\pi\sigma^2_0}}\exp\left(-\frac{1}{2\sigma^2_0}(\mu-\mu_0)^2\right)$$

여기서 $\mu$ 만 변수이므로, $\mu$ 에 대한 거 아니면 모두 날아간다.

$$= \exp\left(-\frac{1}{2\sigma^2}\sum (y_i-\mu)^2-\frac{1}{2\sigma^2_0}(\mu-\mu_0)^2\right)$$

$$= \exp\left(-\frac{1}{2\sigma^2}\left(\sum y^2_i-2n\bar{y}\mu+n\mu^2\right)-\frac{1}{2\sigma^2_0}(\mu-\mu_0)^2\right)$$

$$= \exp\left(-\frac{1}{2}\left(\frac{\sum y_i^2-2n\bar{y}\mu+n\mu^2}{\sigma^2}+\frac{\mu^2-2\mu\mu_0+\mu^2_0}{\sigma_0^2}\right)\right)$$

$$= \exp\left(-\frac{1}{2}\cdot\frac{\sigma^2_0n\mu^2+\sigma^2\mu^2-2\sigma^2_0n\bar{y}\mu-2\sigma^2\mu_0\mu}{\sigma^2\sigma^2_0}\right)$$

(이걸 $N(\circ,\square)$ 꼴로 만들어야 한다.)

$$= \exp\left(-\frac{1}{2}\cdot\frac{1}{\sigma^2\sigma^2_0}(\sigma^2_0n\mu^2+\sigma^2\mu^2-2(\sigma^2_0n\bar{y}+\sigma^2\mu_0)\mu)\right)$$

$$= \exp\left(-\frac{1}{2}\cdot\frac{1}{\sigma^2\sigma^2_0}((\sigma^2_0n+\sigma^2)\mu^2-2(\sigma^2_0n\bar{y}+\sigma^2\mu_0)\mu)\right)$$

$$= \exp\left(-\frac{1}{2}\cdot\frac{\sigma^2_0n+\sigma^2}{\sigma^2\sigma^2_0}\left(\mu^2-2\left(\frac{\sigma^2_0n\bar{y}+\sigma^2\mu_0}{\sigma^2_0n+\sigma^2}\right)\mu\right)\right)$$

따라서

$$\mathbf{E}(\mu|\sigma^2,\vec{y}) = \frac{\sigma^2_0n\bar{y}+\sigma^2\mu_0}{\sigma^2_0n+\sigma^2} = \frac{\dfrac{n\bar{y}}{\sigma^2}+\dfrac{\mu_0}{\sigma^2_0}}{\dfrac{n}{\sigma^2}+\dfrac{1}{\sigma^2_0}}$$

$$\mathrm{Var}(\mu|\sigma^2,\vec{y}) = \frac{\sigma^2\sigma^2_0}{\sigma^2_0n+\sigma^2} = \frac{1}{\dfrac{n}{\sigma^2}+\dfrac{1}{\sigma^2_0}}$$

따라서

$$\pi(\mu|\sigma^2,y) \sim N\left(\frac{\dfrac{n\bar{y}}{\sigma^2}+\dfrac{\mu_0}{\sigma^2_0}}{\dfrac{n}{\sigma^2}+\dfrac{1}{\sigma^2_0}},\ \frac{1}{\dfrac{n}{\sigma^2}+\dfrac{1}{\sigma^2_0}}\right)$$

## $\sigma^2$ 의 조건부 분포 유도

마찬가지로, $\sigma^2$ 에 대한 posterior를 계산한다.

$$P(\sigma^2|\mu,y_1,\dots,y_n) \propto P(y_1,\dots,y_n|\mu,\sigma^2)P(\mu)P(\sigma^2) \quad (\mu \perp \sigma^2)$$

$$\propto P(y_1,\dots,y_n|\mu,\sigma^2)P(\sigma^2) \quad (P(\mu) \text{ known} \to \text{상수 취급})$$

$P(\sigma^2) \sim IG(a,b)$ 이므로 다음과 같이 쓸 수 있다.

$$P(y_1,\dots,y_n|\mu,\sigma^2)P(\sigma^2) = \left(\frac{1}{\sqrt{2\pi\sigma^2}}\right)^n\prod_{i=1}^{n}\exp\left(-\frac{1}{2\sigma^2}(y_i-\mu)^2\right) \times (\sigma^2)^{-(a+1)}\exp\left(-\frac{b}{\sigma^2}\right)$$

(여기서 $\sigma^2$ 만 변수이므로, $\sigma^2$ 에 대한 거 아니면 모두 날아간다.)

$$= (2\pi\sigma^2)^{-\frac{n}{2}}\cdot (\sigma^2)^{-(a+1)}\cdot\exp\left(-\frac{1}{2\sigma^2}\sum(y_i-\mu)^2-\frac{b}{\sigma^2}\right)$$

$$= (2\pi)^{-\frac{n}{2}}\cdot(\sigma^2)^{-\frac{n}{2}}\cdot(\sigma^2)^{-(a+1)}\cdot\exp\left(-\frac{1}{\sigma^2}\left(\frac{\sum(y_i-\mu)^2}{2}+b\right)\right)$$

(이걸 $IG(\circ,\square)$ 꼴로 만든다.)

$$= (\sigma^2)^{-(a+\frac{n}{2}+1)}\cdot\exp\left(-\frac{\dfrac{\sum(y_i-\mu)^2}{2}+b}{\sigma^2}\right)$$

따라서

$$\pi(\sigma^2|\mu,\vec{y}) \sim IG\left(a+\frac{n}{2},\ b+\frac{\sum(y_i-\mu)^2}{2}\right)$$

## 사후 분포 정리

이런 식으로 $\mu, \sigma^2$ 에 대한 posterior를 구하면 아래와 같다.

1. $$\pi(\mu|\sigma^2,\vec{y})\sim N\left(\frac{\dfrac{n\bar{y}}{\sigma^2}+\dfrac{\mu_0}{\sigma^2_0}}{\dfrac{n}{\sigma^2}+\dfrac{1}{\sigma^2_0}},\ \frac{1}{\dfrac{n}{\sigma^2}+\dfrac{1}{\sigma^2_0}}\right)$$

   ($\sigma^2$ 은 모르니까 처음에는 1을 넣어준다.)

2. $$\pi(\sigma^2|\mu,\vec{y})\sim IG\left(a+\frac{n}{2},\ b+\frac{\sum(y_i-\mu)^2}{2}\right)$$

여기서 $\mu_0, \sigma^2_0, a, b$ 는 hyperparameter다.

## Gibbs Sampling 알고리즘

이제 1에서 $\mu$ 하나 뽑는다 ($\to \mu^{(1)}$ 추출).

그리고 나서, 2에 $\mu^{(1)}$ 을 넣어 $\sigma^2$ 을 뽑는다 ($\to \sigma^{2(1)}$).

그 다음에, 1에 $\sigma^{2(1)}$ 을 넣어 $\mu^{(2)}$ 를 뽑는다.

다시 2에 $\mu^{(2)}$ 를 넣고 $\sigma^{2(2)}$ 을 뽑는다.

…

이런 식으로 총 2만 번 sampling한다.

초기값의 영향을 받을 수 있기 때문에 그 중 앞의 만 개는 버리고, 뒤의 만 개를 갖고 근사화된 분포를 구한다. 그러면 원래 joint distribution과 비슷한 분포를 얻게 된다.

---

> 원문: <https://chaeniverse.tistory.com/54>
