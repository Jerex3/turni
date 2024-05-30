import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class DropdownWidget extends StatefulWidget {
  
  const DropdownWidget({super.key, required this.child, required this.menuWidget, required this.dropdownController, this.aligned});

  final Widget child;
  final Widget menuWidget;
  final DropdownController dropdownController;
  final Aligned? aligned;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
    bool isVisible = false;

  @override
  void initState() {
    initializeDropdowncontroller();
    super.initState();
  }

  void initializeDropdowncontroller() {
       widget.dropdownController.hide = () {
        setState(() {
          isVisible = false;
        });
    };
    widget.dropdownController.show = () {
      setState(() {
        isVisible = true;
      });
    };
    
    widget.dropdownController.toggle = () {
      setState(() {
        isVisible = !isVisible;
      });
    };
  }
  

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: isVisible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) {
          setState(() {
            isVisible = false;
          });
        },        
      ),
      child: PortalTarget(
        visible: isVisible,
        anchor: aligment(),
        portalFollower: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: isVisible ? 1.0 : 0.0),
            duration: kThemeAnimationDuration,
            curve: Curves.easeOut,
            builder: (context, progress, child) {
              return Transform(
                transform: Matrix4.translationValues(0, (progress - 1) * 50, 0),
                child: Opacity(
                  opacity: progress,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 300,

              decoration:  BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.1)
                  )
                ]
              ),
              child: widget.menuWidget,
            )),
        child: widget.child,
      ),
    );
  }

  
  Aligned aligment() {
    
    if(widget.aligned != null) return widget.aligned!;

    return const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
          shiftToWithinBound:  AxisFlag(x: true,y: true ));
  }

}

class DropdownController {

  Function()? hide;
  Function()? show;
  Function()? toggle;
  void dispose() {
    hide = null;
    show = null;
    toggle = null;
  }
}