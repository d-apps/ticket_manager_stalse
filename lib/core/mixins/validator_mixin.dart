mixin FieldValidatorMixin {
  String? validateEmpty(String? value){
    if(value == null || value.isEmpty){
      return "Este campo é obrigatório!";
    }
    return null;
  }
}