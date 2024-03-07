import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToolboxScreen(),
    );
  }
}

class ToolboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toolbox'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'web//setting.jpg',
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Toolbox App!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderPredictor extends StatefulWidget {
  @override
  _GenderPredictorState createState() => _GenderPredictorState();
}

class _GenderPredictorState extends State<GenderPredictor> {
  String name = '';
  String gender = '';
  Color color = Colors.transparent;

  Future<void> fetchGender(String name) async {
    final response =
        await http.get(Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        gender = data['gender'];
        color = gender == 'male' ? Colors.blue : Colors.pink;
      });
    } else {
      throw Exception('Failed to load gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gender Predictor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter a name:'),
            TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                fetchGender(name);
              },
              child: Text('Predict Gender'),
            ),
            SizedBox(height: 20),
            gender.isNotEmpty
                ? Text(
                    'Predicted gender: $gender',
                    style: TextStyle(color: color),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class _AgePredictorScreenState extends State<AgePredictorScreen> {
  String _name = '';
  int _age = 0;

  Future<void> _getAge(String name) async {
    final response =
        await http.get(Uri.parse('https://api.agify.io/?name=$name'));
    final responseData = json.decode(response.body);
    setState(() {
      _age = responseData['age'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age Predictor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                _getAge(_name);
              },
              child: Text('Predict Age'),
            ),
            SizedBox(height: 20),
            Text(
              'Age: $_age',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            if (_age < 30)
              Column(
                children: [
                  Text('You are young!'),
                  Image.asset(
                    'assets/young.jpg',
                    width: 200,
                  ),
                ],
              )
            else if (_age >= 30 && _age < 60)
              Column(
                children: [
                  Text('You are an adult!'),
                  Image.asset(
                    'assets/adult.jpg',
                    width: 200,
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text('You are old!'),
                  Image.asset(
                    'assets/old.jpg',
                    width: 200,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class UniversityFinderScreen extends StatefulWidget {
  @override
  _UniversityFinderScreenState createState() => _UniversityFinderScreenState();
}

class _UniversityFinderScreenState extends State<UniversityFinderScreen> {
  List<dynamic> _universities = [];

  Future<void> _getUniversities(String country) async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'));
    final responseData = json.decode(response.body);
    setState(() {
      _universities = responseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University Finder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter country name (e.g., Dominican Republic)',
              ),
              onSubmitted: (value) {
                _getUniversities(value);
              },
            ),
            ElevatedButton(
              onPressed: () {
                _getUniversities('Dominican Republic');
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _universities.length,
                itemBuilder: (context, index) {
                  final university = _universities[index];
                  return ListTile(
                    title: Text(university['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Domain: ${university['domains'].join(', ')}'),
                        Text('Website: ${university['web_pages'].join(', ')}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final data = await WeatherService.getWeather();
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      print('Error loading weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in Santo Domingo'),
      ),
      body: _weatherData != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${_weatherData!['weather'][0]['main']}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${_weatherData!['main']['temp']}°C',
                  style: TextStyle(fontSize: 48),
                ),
                Text(
                  'Humidity: ${_weatherData!['main']['humidity']}%',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordPress News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordPressScreen(),
    );
  }
}

class WordPressScreen extends StatefulWidget {
  @override
  _WordPressScreenState createState() => _WordPressScreenState();
}

class _WordPressScreenState extends State<WordPressScreen> {
  List<dynamic>? _posts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final data = await WordPressService.getPosts();
      setState(() {
        _posts = data['posts'].take(3).toList();
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPress News'),
      ),
      body: _posts != null
          ? ListView.builder(
              itemCount: _posts!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(_posts![index]['featured_image']),
                  title: Text(_posts![index]['title']),
                  subtitle: Text(_posts![index]['excerpt']),
                  onTap: () {
                    // Abrir el enlace original de la noticia en un navegador
                    // externo
                    launch(_posts![index]['URL']);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
      ),
      body: Center(
        child: Text(
          'Página principal',
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Acerca de'),
              onTap: () {
                Navigator.pop(context); // Cerrar el drawer
                Navigator.pushNamed(
                    context, '/about'); // Navegar a la pantalla Acerca de
              },
            ),
          ],
        ),
      ),
    );
  }
}
