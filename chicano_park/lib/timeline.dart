part of mainlib;

Widget timeline(BuildContext context) {
  return Container(
    height: 200,
    //width: 200,
    child: ListView(
      padding: const EdgeInsets.all(8),
      //was horizonatal 
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPage("Part 1: The Takeover", 1),
              ),
            );
          },
          child: Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text("1800s - 1972:"),
                          Text("The Takeover")
                        ],
                      )),
                  elevation: 3,
                ),
                CustomPaint(
                  painter: ShapesPainter(),
                  child: Container(
                    width: 200,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPage("Part 2: Murals Appeared", 2),
              ),
            );
          },
          child: Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text("1960 - 1983:"),
                          Text("Murals Appeared")
                        ],
                      )),
                  elevation: 3,
                ),
                CustomPaint(
                  painter: ShapesPainter(),
                  child: Container(
                    width: 200,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPage("Part 3: Restoration", 3),
              ),
            );
          },
          child: Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text("1986 - Present:"),
                          Text("Restoration")
                        ],
                      )),
                  elevation: 3,
                ),
                CustomPaint(
                  painter: ShapesPainter(),
                  child: Container(
                    width: 200,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPage("Part 4: Present Day", 4),
              ),
            );
          },
          child: Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text("Present Day:"),
                          Text("Current State")
                        ],
                      )),
                  elevation: 3,
                ),
                CustomPaint(
                  painter: ShapesPainter(),
                  child: Container(
                    width: 200,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
