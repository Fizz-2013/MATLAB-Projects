MATLAB-Projects
===============

A collection of MATLAB tools and programs. Some are designed to be used as apps, others, as functions or scripts.

####Installing the Repository
To use the functions here, you must first clone the repository onto your computer using Git.

If you are inexperienced using Git with Terminal, then you can use the GUI Applications.

#####Using Terminal
Simply run:

`git clone (url)`

where `(url)` is the repository address (which should be displayed on the right of the [GitHub page](https://github.com/Fizz-2013/MATLAB-Projects)).

Now you should have the repository on your local machine. Enjoy!


- - -
#CurvePlotter3D

A robust tool used to display graphical and mathematical information about 3D line curves, parametrized with respect to time. (This can be used in conjunction with Vector Calculus courses such as MATH 317)

####Starting up the program

1. Open MATLAB
2. In the *Current Folder* window, drag `CurvePlotter3D.m` into the *Command Window*, this will run the program.
3. Voila! Simple as that!


####Instructions

Most of the controls are self-explanatory, but if you need extra help, simply hover your mouse cursor over a control, a help string will pop-up.

Some useful features:
- You can toggle *To-Scale* viewing in the bottom right portion of the program; this shows the curve according to real aspect ratios.
- Toggle position `r(t)`, velocity `r'(t)`, acceleration `r''(t)`, as well as the tangent `T(t)`, normal `N(t)`, and binormal `B(t)` vectors simply by pressing the labels.
- View the exact answers of evaluations by toggling the *Exact-Values* in the bottom right.
- Play the motion of the particle at a specified rate in the bottom right.
- Rotate, zoom, and toggle grid using the plot toolbar at the top of the program.
- Calculate the Line Integral along the curve, either of a Vector Field type, or a Scalar Function.
- Find the length of the curve, as well as the distance travelled from the start time.


#parseResistance

A simple resistor calculator that has the extra *'parallel'* operator.

`parseResistance`, with no arguments, prompts the user for the layout of the Resistors in a circuit.

To type the layout of a circuit, use numbers for the resistance values, and the operators:
- `+` for adding two resistors in series
- `//` for adding two resistors in parallel

Brackets are allowed, and the order of operations is BDMPAS = Brackets, Division, Multiplication, Parallel, Addition, Subtraction.

The function then returns the equivalent resistance.

`parseResistance(inputString)` returns the equivalent resistance of the given `inputString`.

