import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => carSpeed(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider Example'),
        ),
        body: Consumer<carSpeed>(builder: (context , carSpeed ,child){
          return Column(
            children: [
              Center(child: Text(carSpeed.speed.toString()),)
            ],
        );}
        
      ),
      
    )
    );
    
  }
  
}
class carSpeed extends ChangeNotifier {
  int speed = 0;
  void speedTrack(){
    
  }
}