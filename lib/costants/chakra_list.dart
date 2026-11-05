import 'package:flutter/material.dart';
import 'package:soul_frequency/models/chakra_model.dart';

MudraModel prithviMudra = MudraModel("Prithvi Mudra", "Mudra della Terra per radicamento e stabilità", "Unisci la punta del pollice e dell'anulare, tieni le altre dita estese");
MudraModel shaktiMudra = MudraModel("Shakti Mudra", "Mudra per creatività e energia femminile", "Piega anulare e mignolo, avvicina i pollici, indice e medio estesi");
MudraModel rudraMudra = MudraModel("Rudra Mudra", "Mudra del potere personale e forza interiore", "Unisci pollice, indice e anulare, mignolo e medio estesi");
MudraModel padmaMudra = MudraModel("Padma Mudra", "Mudra del loto per aprire il cuore", "Unisci i polsi, tocca pollici e mignoli, apri le altre dita come petali");
MudraModel granthitaMudra = MudraModel("Granthita Mudra", "Mudra per comunicazione chiara", "Intreccia le dita, indici estesi verso l'alto");
MudraModel hakiniMudra = MudraModel("Hakini Mudra", "Mudra per concentrazione e intuizione", "Unisci le punte di tutte le dita tra loro");
MudraModel mahasirsMudra = MudraModel("Mahasirs Mudra", "Mudra della grande testa per connessione spirituale", "Pollice, indice e medio uniti, anulare e mignolo piegati nel palmo");


List<ChakraModel> chakraList = [
  ChakraModel("Radice", "Muladhara","assets/muladhara.jpg", Colors.red, "Stabilità, sicurezza e radicamento", 396, 6, "Base della colonna", "Terra",false, prithviMudra),
  ChakraModel("Sacrale", "Svadhisthana","assets/svadhisthana.jpg", Colors.orange, "Cretività emozioni e sessualità", 417, 6, "Sotto l'ombelico", "Acqua",false, shaktiMudra),
  ChakraModel("Plesso solare", "Manipura","assets/manipura.jpg", Colors.yellow, "Potere personale e volontà", 528, 6, "Plesso solare", "Fuoco",false, rudraMudra),
  ChakraModel("Cuore", "Anahata","assets/anahata.jpg", Colors.green, "Amore, compassione e guarigione", 639, 6, "Cuore", "Aria",false, padmaMudra),
  ChakraModel("Gola", "Vishuddha","assets/vishuddha.png", Colors.blue, "Comunicazione e autoespressione", 741, 6, "Gola", "Etere",false, granthitaMudra),
  ChakraModel("Terzo occhio", "Ajna","assets/ajna.png", Colors.indigo, "intuizione e saggezza interiore", 852, 6, "Fronte", "Luce",false, hakiniMudra),
  ChakraModel("Corona", "Sahasrara","assets/sahasrara.png", Colors.deepPurple, "Connessione spirituale e illuminazione", 963, 6, "Sommità del capo", "Cosmo",false, mahasirsMudra),
];