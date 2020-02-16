
## Práctica 2: Sólido de revolución

###### Alberto Ramos Sánchez

En esta práctica hemos desarrollado un editor que recoge puntos de un perfil de un objeto sólido que se formará al hacer rotar dicho perfil sobre un eje.

#### Interfaz

Existen dos modos de vista: el modo edición, donde podemos diseñar un perfil; y el modo vista 3D, donde visualizar el sólido generado a partir del perfil dibujado. Para cambiar de modo se utiliza la tecla *Enter*.

Los puntos los indicamos con el ratón cuando estamos en el modo dibujo. Para seleccionar la precisión de la figura 3D (el número de veces que se rota el perfil) seleccionamos con las flechas un valor entre 1 y 500. Una vez tengamos nuestro perfil, generamos el sólido pulsando en la tecla *enter*.

#### Diseño del perfil y creación de la figura 3D.

Cada vez que el usuario pulsa con el ratón en el modo dibujo, se selecciona el punto en la pantalla y se almacena. Adicionalmente, dibujamos en pantalla la línea que une el punto nuevo con el último dibujado.

Todos los puntos creados se almacenan en la clase *Curve*. Cuando el usuario pasa a modo vista 3D, se rota el perfil tantas veces como indique el valor de precisión actual, un ángulo de 2π/precisión. Todas las *Curve* generadas se almacenan para posteriormente dibujarlas.

```java
Shape buildShape(Curve c, int threshold) {
  Shape shape = new Shape();

  float step = (2*PI)/threshold;
  float an = 0;
  // Rotamos la curva tantas veces como valor de precisión/threshold
  for(int i = 0; i < threshold; i++) {
    an += step;
    shape.addCurve(currentCurve.rotar(an));
  }
  return shape;
}
```

La rotación se le aplica a una curva rotando cada uno de sus puntos, multiplicando el punto por una matriz de rotación en el eje y.

<img src="https://render.githubusercontent.com/render/math?math=a & b & c\\
d & e & f\\
g & h & i">
