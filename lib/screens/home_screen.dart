import 'package:assignment/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  AnimationController _controller;
  bool _showBottomNavigationBar = false;
  OverlayEntry _overlayEntry;

  final _bottomKey = GlobalKey();

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    final bottomPadding = _bottomKey.currentContext.size.height;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: bottomPadding,
          width: size.width,
          height: 175,
          child: Material(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Use Camera'),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from Gallery'),
                  ),
                  ListTile(
                    leading: Icon(Icons.create),
                    title: Text('Write a Story'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        Container(
          color: Colors.redAccent,
        ),
        Container(
          color: Colors.lightBlue,
        ),
        Container(
          color: Colors.blueGrey,
        ),
        Container(
          color: Colors.orange,
        ),
        Container(
          color: Colors.lightBlueAccent,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      },
      child: Scaffold(
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            _showBottomNavigationBar
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
          ),
          onPressed: () {
            setState(() {
              _showBottomNavigationBar = !_showBottomNavigationBar;
            });
            if (_showBottomNavigationBar) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
        bottomNavigationBar: SizeTransition(
          sizeFactor: _controller,
          axisAlignment: -1,
          child: CustomBottomNavigationBar(
            key: _bottomKey,
            type: BottomNavigationBarType.shifting,
            currentIndex: _currentIndex,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.white,
            // selectedItemColor: Colors.black,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (_currentIndex == 2) {
                if (_overlayEntry == null) {
                  _overlayEntry = _createOverlayEntry();
                  Overlay.of(context).insert(_overlayEntry);
                }
              } else {
                _overlayEntry?.remove();
                _overlayEntry = null;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeIcon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: Text('Store'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('Add'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                title: Text('Explore'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
