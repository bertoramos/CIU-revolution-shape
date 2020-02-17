
## Práctica 2: Sólido de revolución

###### Alberto Ramos Sánchez

<center><img src="export.gif" width="400" height="400" alt="Ventana de programa (GIF)"/></center>

En esta práctica hemos desarrollado un editor que recoge puntos de un perfil de un objeto sólido que se formará al hacer rotar dicho perfil sobre un eje.

#### Interfaz

Existen dos modos de vista: el modo edición, donde podemos diseñar un perfil; y el modo vista 3D, donde visualizar el sólido generado a partir del perfil dibujado. Para cambiar de modo se utiliza la tecla *Enter*.

Los puntos los indicamos con el ratón cuando estamos en el modo dibujo. Para seleccionar la precisión de la figura 3D (el número de veces que se rota el perfil) seleccionamos con las flechas un valor entre 1 y 500. Una vez tengamos nuestro perfil, generamos el sólido pulsando en la tecla *enter*.

#### Diseño del perfil y creación de la figura 3D.

Cada vez que el usuario pulsa con el ratón en el modo dibujo, se selecciona el punto en la pantalla y se almacena. Adicionalmente, dibujamos en pantalla la línea que une el punto nuevo con el último dibujado.

```java
// Vértice de perfil
strokeWeight(3);
PShape ppoint = createShape(POINT, new_point.x, new_point.y);
shape(ppoint);
strokeWeight(1);

// Linea entre ultimo vertice y nuevo vertice
if(currentCurve.nVertex() > 0) {
  Point last = currentCurve.getLastVertex();
  PShape path = createShape(LINE, last.x, last.y, new_point.x, new_point.y);
  shape(path);
}
```

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


<center><img src="https://latex.codecogs.com/gif.latex?%28x_2%2C%20y_2%2C%20z_2%29%20%3D%20%5Cbegin%7Bpmatrix%7D%20x_1%2C%20y_1%2C%20z_1%20%5Cend%7Bpmatrix%7D%5Cbegin%7Bpmatrix%7D%20cos%5Ctheta%20%26%200%20%26%20sen%5Ctheta%5C%5C%200%20%26%201%20%26%200%5C%5C%20-sen%5Ctheta%20%26%200%20%26%20cos%5Ctheta%20%5Cend%7Bpmatrix%7D" alt = "Matriz de rotación"/></center>

### Generación de la malla 3D.

Para generar el *PShape* que se mostrará en pantalla, unimos los vértices de cada perfil con *TRIANGLE_STRIP*. Unimos cada *curve* con su sucesivo, enlazando los vértices a la misma altura. Para evitar que se unan los vértices de la parte superior con los de la inferior, cada vez que cambiamos de pareja de perfiles, cambiamos también el sentido de recorrido de los vértices.

```java
public PShape createMesh() {
  PShape pshape = createShape();
  pshape.beginShape(TRIANGLE_STRIP);
  pshape.noFill();

  // Zig-zag
  for(int i = 0; i < shape.size()-1; i++) {
    if(i % 2 == 0) { // De arriba a abajo
      for(int j = 0; j < shape.get(i).nVertex(); j++) {
        Point p0 = shape.get(i).get(j);
        Point p1 = shape.get(i+1).get(j);
        pshape.vertex(p0.x, p0.y, p0.z);
        pshape.vertex(p1.x, p1.y, p1.z);
      }
    } else { // De abajo hacia arriba
      for(int j = shape.get(i).nVertex()-1; j >= 0; j--) {
        Point p0 = shape.get(i).get(j);
        Point p1 = shape.get(i+1).get(j);
        pshape.vertex(p0.x, p0.y, p0.z);
        pshape.vertex(p1.x, p1.y, p1.z);
      }
    }
  }

  // Ultimo perfil con el primero
  int i = shape.size()-1;
  if(i % 2 == 0) { // De arriba a abajo
    for(int j = 0; j < shape.get(i).nVertex(); j++) {
      Point p0 = shape.get(i).get(j);
      Point p1 = shape.get(0).get(j);
      pshape.vertex(p0.x, p0.y, p0.z);
      pshape.vertex(p1.x, p1.y, p1.z);
    }
  } else { // De abajo a arriba
    for(int j = shape.get(i).nVertex()-1; j >= 0; j--) {
      Point p0 = shape.get(i).get(j);
      Point p1 = shape.get(0).get(j);
      pshape.vertex(p0.x, p0.y, p0.z);
      pshape.vertex(p1.x, p1.y, p1.z);
    }
  }
  pshape.endShape(CLOSE);

  return pshape;
}
```
