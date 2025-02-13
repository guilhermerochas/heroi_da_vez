import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heroi_da_vez/app/widgets/heroi_da_vez_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../data/models/incident_case.dart';

class IncidentDetailCardItem extends StatelessWidget {
  final IncidentCase incidentCase;

  const IncidentDetailCardItem({
    Key? key,
    required this.incidentCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _contentCardContainer(),
        const SizedBox(
          height: 20,
        ),
        _contactsCardContainer(),
      ],
    );
  }

  Widget _contactsCardContainer() {
    return Card(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      color: Colors.white,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 30,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Seja um Heroi!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Entre em contato:",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                const Expanded(
                  child: HeroiDaVezButton(
                    buttonText: "WhatsApp",
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: HeroiDaVezButton(
                    buttonText: "E-mail",
                    onPressed: () async => await _sendMail(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _sendMail() async {
    try {
      var uri = Uri(
        scheme: 'mailto',
        path: incidentCase.organization.target?.email,
        queryParameters: {
          'subject': 'Ajude a esta caúsa',
          'body': '''
          Olá, a causa de ${incidentCase.caseName} com a descrição: ${incidentCase.description}.

          Está precisando de uma doação de R\$ ${incidentCase.valueCost}, poderia nos ajudar?
        ''',
        },
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } on Exception catch (exception) {
      if (kDebugMode) {
        print(exception.toString());
      }
    }
  }

  Widget _contentCardContainer() {
    return Card(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      color: Colors.white,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "CASO: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      incidentCase.caseName,
                    )
                  ],
                ),
                const SizedBox(
                  width: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "ONG: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      incidentCase.organization.target!.name,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Descrição: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              incidentCase.description,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Valor: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "R\$ ${incidentCase.valueCost} reais",
            ),
          ],
        ),
      ),
    );
  }
}
