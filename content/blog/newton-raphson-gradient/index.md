---
title: "Newton-Raphson Method & Gradient Method"
date: 2023-01-27
summary: "곡선의 접선을 따라 해(또는 극점)에 점차 접근하는 두 반복법: Newton-Raphson과 gradient method. 같은 예제 y = x²로 두 업데이트 식을 비교한다."
tags:
  - Statistics
  - Optimization
  - Numerical Methods
  - Gradient Descent
authors:
  - me
featured: true
---

곡선의 접선을 그리고, 그 접선이 알려주는 방향으로 한 걸음씩 옮겨가며 해 (또는 극점) 에 가까워지는 두 가지 반복적인 방법을 정리한다. 같은 예제 $y = x^2$ 로 비교한다.

## Newton-Raphson Method

방정식 $f(x) = 0$ 의 해를 구하는 방법. 현재 위치 $x_n$ 에서 곡선의 **접선**을 그리고, 그 접선이 $x$ 축과 만나는 점을 다음 위치 $x_{n+1}$ 로 삼는다.

접선의 식:

$$y = f(x_n) + f'(x_n)(x - x_n)$$

이 직선이 $y=0$ 이 되는 $x$ 를 풀면

$$x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}$$

### 예제: $y = x^2$

$f(x) = x^2$, $f'(x) = 2x$ 이므로

$$x_{n+1} = x_n - \frac{x_n^2}{2x_n} = x_n - \frac{x_n}{2} = \frac{x_n}{2}$$

$x_0 = 8$ 부터 시작하면 $x_1 = 4, x_2 = 2, x_3 = 1, \dots$ 매 step마다 절반으로 줄어들며 해 $x^* = 0$ 에 접근한다. (그림에서 $x_0 \to x_1 \to x_2 \to \dots \to x^*$)

## Gradient Method

함수 $f(x)$ 의 **극점(보통 최솟값)** 을 찾는 방법. 현재 위치 $x_n$ 에서 그래디언트(도함수)의 반대 방향으로 step size $\alpha$ 만큼 이동한다.

$$x_{n+1} = x_n - \alpha \cdot f'(x_n)$$

여기서 $\alpha$ 는 한 번에 너무 크게 이동하는 것을 방지하기 위한 **하이퍼파라미터** (learning rate / step size). 이 $\alpha$ 를 어떻게 적응적으로 조절하느냐가 **AdaGrad, Adam** 같은 옵티마이저 변종의 핵심.

### 예제: $y = x^2$

$f'(x) = 2x$, $\alpha = 0.1$ 이라고 하자. $x^{(1)} = 5$ 부터 시작하면

$$x^{(2)} = 5 - 0.1 \cdot 2 \cdot 5 = 5 - 1 = 4$$

$$x^{(3)} = 4 - 0.1 \cdot 2 \cdot 4 = 4 - 0.8 = 3.2$$

$$\vdots$$

일반화하면

$$x^{(i+1)} = x^{(i)} - \alpha \cdot f'(x^{(i)})$$

매 step마다 $x$ 가 $0.8$ 배씩 (= $1 - 2\alpha$) 줄어들며 $x^* = 0$ 에 접근한다.

## 두 방법 비교

|  | Newton-Raphson | Gradient Method |
|---|---|---|
| 목적 | $f(x) = 0$ (해 찾기) | $\min f(x)$ (극점 찾기) |
| 업데이트 | $x_{n+1} = x_n - f(x_n)/f'(x_n)$ | $x_{n+1} = x_n - \alpha \cdot f'(x_n)$ |
| step size | 자동 (도함수 비) | 수동 (하이퍼파라미터 $\alpha$) |
| 필요 정보 | $f, f'$ | $f'$ |
| 수렴 속도 | 보통 빠름 (이차 수렴) | $\alpha$에 의존 (보통 일차) |

> 참고: 최적화 맥락에서 Newton's method ("Newton's optimization") 는 $f'(x) = 0$ 의 해를 Newton-Raphson으로 찾는 것이라 $x_{n+1} = x_n - f'(x_n)/f''(x_n)$ 형태가 된다. 이때는 2차 도함수 $f''$ 가 필요하다.

---

> 원문: <https://chaeniverse.tistory.com/13>
