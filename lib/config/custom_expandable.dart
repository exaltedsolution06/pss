import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:picturesourcesomerset/config/app_color.dart';

class ExpandableSection extends StatelessWidget {
  final String headerText;
  final double width;
  final IconData? headerIcon;
  final IconData? expandIcon;
  final IconData? collapseIcon;
  final Widget body;
  final void Function()? onHeaderTap;
  final bool initialExpanded;

  ExpandableSection({
    required this.headerText,
    required this.body,
    required this.width,
    this.headerIcon,
    this.expandIcon,
    this.collapseIcon,
    this.onHeaderTap,
	this.initialExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Create ExpandableController
    final expandableController = ExpandableController(initialExpanded: initialExpanded);

    return SizedBox(
      width: width,
      child: ExpandableNotifier(
        controller: expandableController,
        child: Column(
          children: [
            Expandable(
              collapsed: GestureDetector(
                onTap: () {
                  expandableController.toggle(); // Toggle expansion state
                  if (onHeaderTap != null) onHeaderTap!(); // Call header tap callback
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.Greyscale,
                   /* borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(35),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(35),
                    ),*/
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (headerIcon != null) Icon(headerIcon),
                          const SizedBox(width: 8),
                          Text(headerText),
                        ],
                      ),
                      Icon(expandIcon ?? Icons.expand_more),
                    ],
                  ),
                ),
              ),
              expanded: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      expandableController.toggle(); // Toggle expansion state
                      if (onHeaderTap != null) onHeaderTap!(); // Call header tap callback
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.Greyscale,
                        /*borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(35),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(35),
                        ),*/
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (headerIcon != null) Icon(headerIcon),
                              const SizedBox(width: 8),
                              Text(headerText),
                            ],
                          ),
                          Icon(collapseIcon ?? Icons.expand_less),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      /*borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(35),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(35),
                      ),*/
                      border: Border.all(color: AppColor.Greyscale),
                    ),
                    child: body,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
