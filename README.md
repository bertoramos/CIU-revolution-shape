
## Práctica 2: Sólido de revolución

###### Alberto Ramos Sánchez

<center><img src="export.gif" width="400" height="400" alt="Ventana de programa (GIF)"/></center>

En esta práctica hemos desarrollado un editor que recoge puntos de un perfil de un objeto sólido que se formará al hacer rotar dicho perfil sobre un eje.

#### Uso de la Interfaz

- En *vista diseño*:
  - __&#8617;__ __*Enter*__ : cambiar a vista diseño.
  - &#11014;&#11015; __*Flechas superiores e inferiores*__ :  cambiar el valor de precisión (número de rotaciones del perfil) en paso 1.
  - &#11013;&#10145; __*Flechas izquierda y derecha*__ : cambiar el valor de precisión en paso 50.
  - &#128432; __*Click izquierdo*__ : indicar puntos (uno a uno) del perfil en modo dibujo.
  - &#128432; __*Click derecho*__ : eliminar último punto dibujado.
- En *vista 3D*:
  - __&#8617;__ __*Enter*__ : cambiar a vista dibujo.
  - &#11014;&#11015; __*Flechas superiores e inferiores*__ : girar el objeto en el eje X.
  - __&#9398;/&#9442;__ __*Teclas A y S*__: girar el objeto en el eje Y.
  - &#11013;&#10145; __*Flechas izquierda y derecha*__ : girar el objeto en el eje Z.
  - &#128432; __*Desplazar puntero*__: desplazar el objeto.

#### Diseño del perfil y creación de la figura 3D.

Cada vez que el usuario pulsa con el ratón (en el modo dibujo), se selecciona el punto en la pantalla y se almacena, trasladándolo al centro de la pantalla: (x - width/2, y - height/2). Para eliminar el último punto dibujado, simplemente lo eliminamos de la curva que se está dibujando.

```java
void mousePressed() {
  if(drawing) {
    if (mouseButton == LEFT) newPoint(mouseX - (width/2), mouseY - (height/2));
    if (mouseButton == RIGHT) currentCurve.removeLastVertex();
  }
}
```

Para mostrar al usuario la forma de la curva, actualizamos en la función draw la unión de los vértices.

```java
void draw() {
  ...
  if(drawing) {
    ...
  } else {
    // Dibujar canvas de dibujo
    drawCanvas();
    // Dibujar valor de precision actual
    drawAccuracyValue();
    // Dibujar curva
    translate(width/2, height/2);
    currentCurve.draw();
  }
}

...

class Curve {
  ...
  // Dibujar curva
  public void draw() {
    for(int i = 0; i < this.points.size(); i++) {
      stroke(255);
      strokeWeight(3);
      PShape ppoint = createShape(POINT, points.get(i).x, points.get(i).y);
      shape(ppoint);
    }

    strokeWeight(1);
    for(int i = 0; i < this.points.size()-1; i++) {
      Point p1 = this.get(i);
      Point p2 = this.get(i+1);
      PShape path = createShape(LINE, p1.x, p1.y, p2.x, p2.y);
      shape(path);
    }
  }
  ...
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

### Referencias

 * __Imagen enter key__ : https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Oxygen480-actions-key-enter.svg/1200px-Oxygen480-actions-key-enter.svg.png
 * __Látex en imagen__ :<https://latex.codecogs.com>
