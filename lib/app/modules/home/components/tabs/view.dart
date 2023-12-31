import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:tabpanel/tabpanel.dart';

class TabsComponent extends StatefulWidget {
  @override
  _TabsComponentState createState() => _TabsComponentState();
}

class _TabsComponentState extends State<TabsComponent> {
  final tabPanel = TabPanel(
    defaultPage: PageA(),
  );


  bool darkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabPanelWidget(tabPanel),
        Positioned(
          bottom: 0,
          right: 0,
          child: Card(
            child: IconButton(
              onPressed: () => setState(() => darkMode = !darkMode),
              icon:
              Icon(darkMode ? Icons.lightbulb : Icons.lightbulb_outlined),
            ),
          ),
        ),
      ],
    );
  }
}

class PageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tab = ParentTab.of(context);
    return Column(
      children: [
        Icon(Icons.construction, size: 56),
        Text('Page A'),
        Divider(),
        Wrap(
          children: [
            OutlinedButton.icon(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => tab?.push(PageB()),
              label: Text('Page B'),
            ),
            SizedBox(width: 16),
            OutlinedButton.icon(
              icon: Icon(Icons.open_in_new),
              onPressed: () => tab?.push(PageB(), forceNewTab: true),
              label: Text('Page B'),
            ),
          ],
        )
      ],
    );
  }
}

class PageB extends StatelessWidget with TabPageMixin {
  @override
  final String title = 'PageB';

  @override
  final Icon icon = const Icon(Icons.dashboard);

  @override
  final IconData iconData = Icons.dashboard;

  @override
  Widget build(BuildContext context) {
    final tab = ParentTab.of(context);
    return Column(
      children: [
        Icon(Icons.construction_outlined, size: 56),
        Text('Page B'),
        Divider(),
        Wrap(
          children: [
            OutlinedButton.icon(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => tab?.push(PageC()),
              label: Text('Page C'),
            ),
            SizedBox(width: 16),
            OutlinedButton.icon(
              icon: Icon(Icons.open_in_new),
              onPressed: () => tab?.push(PageC(), forceNewTab: true),
              label: Text('Page C'),
            ),
            SizedBox(width: 16),
            if ((tab?.pages?.length ?? 0) > 1)
              OutlinedButton.icon(
                icon: Icon(Icons.navigate_before),
                onPressed: tab?.pop,
                label: Text('Go back'),
              ),
          ],
        )
      ],
    );
  }
}

class PageC extends StatelessWidget with TabPageMixin {
  @override
  final String title = 'PageC';

  @override
  final IconData iconData = Icons.work;

  @override
  Widget build(BuildContext context) {
    final tab = ParentTab.of(context);
    return Column(
      children: [
        Icon(Icons.construction_outlined, size: 56),
        Text('Page C'),
        Divider(),
        Wrap(
          children: [
            if ((tab?.pages?.length ?? 0) > 1)
              OutlinedButton.icon(
                icon: Icon(Icons.navigate_before),
                onPressed: tab?.pop,
                label: Text('Go back'),
              ),
          ],
        )
      ],
    );
  }
}