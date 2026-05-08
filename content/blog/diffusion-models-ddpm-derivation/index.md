---
title: "Diffusion Models: DDPM 수식 유도와 응용 (DDIM, LDM)"
date: 2024-05-28
summary: "Diffusion model의 직관(forward/reverse process)부터 ELBO 기반 DDPM loss의 수식 유도, 그리고 DDIM·Diffusion-GAN·LDM 같은 후속 모델들까지 정리한 노트."
tags:
  - Deep Learning
  - Generative AI
  - Diffusion Model
  - DDPM
  - LDM
authors:
  - me
featured: true
---

## Concept

**Diffusion model의 생물학적 원리.** 분자 구조가 퍼져 나가는 모습에서 착안. 예) 물에 잉크가 퍼지는 과정, 공기 중에 연기가 퍼지는 과정.

**수학적 원리.** 분자의 다음 위치는 **gaussian distribution** 에 의해 결정된다.

## Forward / Reverse Process

**Forward process** — 앞선 이미지에 gaussian distribution을 연속적으로 곱해 noise를 추가한다.

**Reverse process** — 같은 가우시안 분포를 곱해 denoising 상태로 복원한다. 학습을 위한 loss term을 구하는 과정에서 $p$ 와 $q$ 의 평균·분산을 알아야 한다.

여기서

- $p$ : 우리가 구하고 싶은, 이미 정해진 정답 pdf
- $q$ : 우리가 학습을 통해 구해야 하는 pdf

## 사전 지식

- **KL divergence** — 두 확률 분포의 차이를 계산. 거리 개념은 아님 (asymmetric).
- **Markov chain** — 현재 상태는 바로 이전 상태의 영향만 받는다.
- **Bayes' theorem**
- **ELBO (Evidence Lower Bound)** — VAE에서 출발한 개념. MLE를 푸는 한 방식.

## VAE에서 ELBO

VAE에서는 latent $z$ 가 주어졌을 때 관측 $x$ 의 분포 $p(x \mid z)$ 를 모델링한다. $p(x)$ 자체는 직접 구하기 어렵고, $q(z \mid x)$ 라는 추정 분포로 우회한다.

KL divergence 정의로부터

$$D_{\mathrm{KL}}(q(z\mid x) \,\|\, p(z\mid x)) = \int q(z\mid x) \log\frac{q(z\mid x)}{p(z\mid x)}\,dz \ge 0$$

이를 풀어서 $\log p(x)$ 만 남기고 정리하면

$$\log p(x) = D_{\mathrm{KL}}(q(z\mid x)\,\|\,p(z\mid x)) - \mathbb{E}_{q(z\mid x)}[\log q(z\mid x)] + \mathbb{E}_{q(z\mid x)}[\log p(x, z)]$$

- $\log p(x)$ 는 **fixed**
- 첫 항 $D_{\mathrm{KL}} \ge 0$ 이고, **이걸 minimize 해야** $q$ 가 $p$ 에 가까워진다
- 그러면 나머지 두 항 (**ELBO**) 은 자연스럽게 maximize 된다

ELBO 부분을 정리하면

$$\mathrm{ELBO} = \mathbb{E}_{q(z\mid x)}\!\left[\log\frac{p(x, z)}{q(z\mid x)}\right]$$

→ 이걸 maximize하는 게 VAE 학습의 핵심.

## VAE → DDPM 연결

DDPM에서는 latent $z$ 자리에 **여러 시점의 noisy state** $x_1, x_2, \dots, x_T$ 가 들어간다 ($x_0$ 는 원본 이미지).

ELBO에 음수를 붙여 minimize 문제로 바꾸면

$$\mathcal{L} = -\mathbb{E}_{q(x_{1:T} \mid x_0)}\!\left[\log\frac{p_\theta(x_{0:T})}{q(x_{1:T} \mid x_0)}\right]$$

이게 DDPM loss의 출발점.

## DDPM Loss 수식 유도

Markov chain 가정 하에서 joint 분포가 chain rule로 분해된다:

$$p_\theta(x_{0:T}) = p(x_T)\prod_{t=1}^{T} p_\theta(x_{t-1} \mid x_t)$$

$$q(x_{1:T} \mid x_0) = \prod_{t=1}^{T} q(x_t \mid x_{t-1})$$

대입 후 로그 전개:

$$\mathcal{L} = \mathbb{E}_q\!\left[-\log p(x_T) + \sum_{t=1}^{T} \log\frac{q(x_t \mid x_{t-1})}{p_\theta(x_{t-1} \mid x_t)}\right]$$

Bayes' theorem과 markov 성질로 $q(x_t \mid x_{t-1}) = q(x_t \mid x_{t-1}, x_0)$ 가 성립하고, 이를 활용해 $q(x_{t-1} \mid x_t, x_0)$ 형태로 변환:

$$q(x_t \mid x_{t-1}, x_0) = \frac{q(x_{t-1} \mid x_t, x_0)\, q(x_t \mid x_0)}{q(x_{t-1} \mid x_0)}$$

이 변환을 적용하면 telescoping이 일어나며 최종적으로 다음의 KL 형태로 정리된다.

$$\mathcal{L} = \mathbb{E}_q\!\left[\underbrace{D_{\mathrm{KL}}(q(x_T \mid x_0)\,\|\,p(x_T))}_{L_T} + \sum_{t=2}^{T} \underbrace{D_{\mathrm{KL}}(q(x_{t-1} \mid x_t, x_0)\,\|\,p_\theta(x_{t-1} \mid x_t))}_{L_{t-1}} \;-\; \underbrace{\log p_\theta(x_0 \mid x_1)}_{L_0}\right]$$

### 학습할 항만 남기기

- $L_T$ — forward process에서만 쓰이고 학습할 파라미터 없음 → **무시**
- $L_0$ — 영향이 미미해서 **무시**
- 결국 **$L_{t-1}$** 만 minimize 하면 됨

### $q(x_{t-1} \mid x_t, x_0)$ 의 평균·분산

Forward process: $q(x_t \mid x_{t-1}) = \mathcal{N}(x_t;\, \sqrt{1-\beta_t}\, x_{t-1},\, \beta_t I)$.

$\alpha_t = 1 - \beta_t$, $\bar\alpha_t = \prod_{s=1}^{t}\alpha_s$ 라 정의하면 reparameterization trick으로

$$q(x_t \mid x_0) = \mathcal{N}(x_t;\, \sqrt{\bar\alpha_t}\,x_0,\, (1-\bar\alpha_t) I)$$

Bayes' theorem과 가우시안 곱 정리로

$$q(x_{t-1} \mid x_t, x_0) = \mathcal{N}\big(x_{t-1};\, \tilde\mu_t(x_t, x_0),\, \tilde\beta_t I\big)$$

여기서

$$\tilde\mu_t(x_t, x_0) = \frac{\sqrt{\bar\alpha_{t-1}}\,\beta_t}{1-\bar\alpha_t}\,x_0 + \frac{\sqrt{\alpha_t}(1-\bar\alpha_{t-1})}{1-\bar\alpha_t}\,x_t$$

$$\tilde\beta_t = \frac{1-\bar\alpha_{t-1}}{1-\bar\alpha_t}\,\beta_t$$

$x_0 = \dfrac{1}{\sqrt{\bar\alpha_t}}\big(x_t - \sqrt{1-\bar\alpha_t}\,\epsilon\big)$ 로 다시 정리하면

$$\tilde\mu_t(x_t, x_0) = \frac{1}{\sqrt{\alpha_t}}\!\left(x_t - \frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\,\epsilon\right)$$

### $p_\theta(x_{t-1} \mid x_t)$ 의 정의

가우시안 분포로 가정하고, 평균을 다음처럼 **네트워크 출력 $\epsilon_\theta$** 의 형태로 둔다:

$$p_\theta(x_{t-1} \mid x_t) = \mathcal{N}\!\big(x_{t-1};\, \mu_\theta(x_t, t),\, \sigma_t^2 I\big)$$

$$\mu_\theta(x_t, t) = \frac{1}{\sqrt{\alpha_t}}\!\left(x_t - \frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\,\epsilon_\theta(x_t, t)\right)$$

→ 두 평균의 차이만 학습하면 되고, 이는 곧 **$\epsilon$ vs $\epsilon_\theta$** 의 차이를 학습하는 것이 된다.

### 가우시안 KL → 평균 차이의 L2

분산이 같은 두 가우시안의 KL은 평균 제곱 차로 환원되므로

$$L_{t-1} = \mathbb{E}_{x_0,\epsilon}\!\left[\frac{\beta_t^2}{2\sigma_t^2\,\alpha_t(1-\bar\alpha_t)} \,\big\|\epsilon - \epsilon_\theta\big(\sqrt{\bar\alpha_t}\,x_0 + \sqrt{1-\bar\alpha_t}\,\epsilon,\; t\big)\big\|^2\right]$$

### 단순화된 최종 loss

DDPM 논문에서는 weight term을 제거한 단순화된 loss를 사용한다:

$$\mathcal{L}_{\text{simple}}(\theta) = \mathbb{E}_{t,\,x_0,\,\epsilon}\!\left[\,\big\|\epsilon - \epsilon_\theta\big(\sqrt{\bar\alpha_t}\,x_0 + \sqrt{1-\bar\alpha_t}\,\epsilon,\; t\big)\big\|^2\,\right], \qquad \epsilon \sim \mathcal{N}(0, I)$$

→ 결국 **U-Net (또는 다른 구조)이 noise $\epsilon$ 을 예측하도록 학습**시키는 단순한 MSE 회귀 문제로 귀결.

## 학습·샘플링 알고리즘 요약

**Training**: $x_0$ 와 $t \sim \mathrm{Unif}(\{1, \dots, T\})$, $\epsilon \sim \mathcal{N}(0, I)$ 을 뽑아 $\mathcal{L}_{\text{simple}}$ 의 SGD로 $\epsilon_\theta$ 를 학습.

**Sampling**: $x_T \sim \mathcal{N}(0, I)$ 부터 시작, $t = T, T-1, \dots, 1$ 까지 reverse step으로

$$x_{t-1} = \frac{1}{\sqrt{\alpha_t}}\!\left(x_t - \frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\,\epsilon_\theta(x_t, t)\right) + \sigma_t z, \quad z \sim \mathcal{N}(0, I)$$

## DDIM (Denoising Diffusion Implicit Models)

> Song et al. (2021)

DDPM은 markov chain을 연속적으로 곱해 process가 이루어져 **샘플링이 느리다** ($T$ 보통 1000).

이를 단축하기 위해 **non-markovian** 개념을 도입. Forward process에서 $x_t$ 분포를 구할 때 $x_{t-1}$ 와 $x_0$ 만으로도 정의 가능 → markov 성질을 가정할 필요 없음. Sampling step을 대폭 줄여도 품질이 유지된다.

가우시안이 아니어도 적용 가능 (이상치가 많은 분포라면 t분포·코시분포 활용 검토 가능).

## Diffusion-GAN

> Wang et al. (2023)

Diffusion model에 GAN의 discriminator를 도입. Generator + Discriminator 구조로,

- Real noise (forward process로 만든 noisy image) 와 fake noise (학습한 모델이 만든 noisy image) 사이의 차이를 discriminator가 판별
- 둘의 차이를 minimize하도록 generator를 학습

## Latent Diffusion Model (LDM)

> Rombach et al. (2022) — *High-Resolution Image Synthesis with Latent Diffusion Models*

기존 diffusion model은 픽셀 공간에서 직접 작동해 **계산량이 많다**. LDM은 이를 줄이기 위해 **차원 축소된 latent space**에서 diffusion을 수행한다.

### Pixel space vs Latent space

- **Pixel space**: 차원 축소되지 않은 고차원
- **Latent space**: 차원 축소된 저차원

이미지의 resolution은 두 측면으로 분해할 수 있다:

- **Semantic** — 사물의 형체만 알아볼 정도의 해상도
- **Perceptual** — 더 디테일한 정보

차원 축소 시 perceptual 정보를 덜어내고 semantic resolution을 보존한다. 이 latent에서 diffusion을 수행한 뒤 decoder로 perceptual 정보를 복원.

### 구조

VAE의 autoencoder 개념이 결합된 구조:

- **$\varepsilon$ (encoder)**: pixel → latent
- **$\mathcal{D}$ (decoder)**: latent → pixel
- **Diffusion** 은 latent space에서 작동

내부적으로는 **U-Net + attention-based transformer** 모듈을 결합. Conditioning ($y$ — 텍스트, 클래스 라벨, semantic map 등) 은 cross-attention으로 주입한다.

### 손실 함수

$$\mathcal{L}_{\mathrm{LDM}} = \mathbb{E}_{z_0,\, y,\, \epsilon,\, t}\!\left[\,\big\|\epsilon - \epsilon_\theta(z_t,\, t,\, y)\big\|_2^2\,\right]$$

→ 픽셀 공간 DDPM의 단순화된 loss와 형태는 같고, **변수만 latent $z$ 와 condition $y$** 로 바뀐 형태.

### 왜 좋은가

- 차원 축소된 공간에서 diffusion → **계산 비용 ↓**
- Latent space는 likelihood 기반 생성 모델에 더 적합
- Semantic 수준에서만 학습되므로 데이터 효율성도 ↑

## 정리

> **DDPM의 loss는 결국 VAE의 ELBO를 markov chain으로 펼친 형태이며, 가우시안 KL이 평균 차의 L2로 환원되어 결국 "noise 예측" 회귀 문제가 된다.**
>
> DDIM은 sampling 가속화, Diffusion-GAN은 GAN과의 결합, LDM은 latent space 활용으로 계산 효율을 끌어올린 후속 작업들.

---

## 참고

- Ho et al., *Denoising Diffusion Probabilistic Models*, NeurIPS 2020
- Song et al., *Denoising Diffusion Implicit Models*, ICLR 2021
- Rombach et al., *High-Resolution Image Synthesis with Latent Diffusion Models*, CVPR 2022
- Wang et al., *Diffusion-GAN: Training GANs with Diffusion*, 2023
