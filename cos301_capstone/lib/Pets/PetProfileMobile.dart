// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PetProfileMobile extends StatefulWidget {
  PetProfileMobile({
    super.key,
    required this.creatingNewPet,
  });

  final bool creatingNewPet;

  @override
  State<PetProfileMobile> createState() => _PetProfileMobileState();
}

class _PetProfileMobileState extends State<PetProfileMobile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
