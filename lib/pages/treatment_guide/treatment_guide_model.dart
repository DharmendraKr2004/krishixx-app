import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'treatment_guide_widget.dart' show TreatmentGuideWidget;
import 'package:flutter/material.dart';

class TreatmentGuideModel extends FlutterFlowModel<TreatmentGuideWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for searchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;

  // State field(s) for issueDropDown widget.
  String? issueDropDownValue;
  FormFieldController<String>? issueDropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
