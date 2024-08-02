import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';
import 'package:poc_pdf_creation/home.dart';
import 'package:poc_pdf_creation/models/index.dart';

void main() {
  runApp(const MyApp());
  // initializeDateFormatting('pt_BR', null).then((_) => runApp(const myApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CurriculumPDFPage(
        curriculum: Curriculum(
          uid: '',
          name: 'Vitor Lucas Pires Cordovil',
          cpf: '95196986200',
          nascimento: '27/02/1994',
          civilState: CivilState.casado,
          sex: Sex.masculino,
          country: 'Brasil',
          qtdFilhos: 1,
          cnh: Cnh.nao,
          veiculoProprio: true,
          disponibilidadeParaViagem: true,
          disponibilidadeParaMudanca: true,
          phone: '(68) 99999-9999',
          email: 'vitor@email.com',
          linkedin: 'https://www.linkedin.com/in/reiko-dev/',
          address: const Address(
            address: 'Av. João Barbudo',
            addressNumber: 1532,
            cep: '69927-000',
            city: 'Porto Acre',
            state: 'Acre',
            neighborhood: 'Vila do Incra',
            complement: 'Em frente à Igreja Católica',
          ),
          desiredPosition: 'Desenvolvedor Fullstack',
          professionalObjectives:
              'Flutter Development Expert with one and a half years of experience building high-quality mobile applications. Proven ability to collaborate effectively and deliver projects on time, particularly within a US work environment. Possess strong UI/UX design skills and a passion for creating user-friendly experiences.',
          academicFormation: [
            AcademicFormation(
              courseName: 'Sistemas de Informação',
              organization: 'Universidade Federal do Acre',
              situation: AcademicSituation.finished,
              formation: Formation.graduation,
              endDate: DateTime(2017, 02),
            ),
            AcademicFormation(
              courseName: 'Medicina',
              organization: 'Universidad Técnica de Pando-Cobija, Bolivia',
              situation: AcademicSituation.finished,
              formation: Formation.graduation,
              // endDate: DateTime(2023, 12),
            ),
          ],
          professionalExperience: [
            ProfessionalExperience(
              company: 'Shaw and Partners',
              context: 'Software Development Company',
              position: 'Mobile Software Developer',
              responsability: """
Developed a cross-platform mobile application prototype (MVP) using Flutter.
  • Led user interface iterations based on user feedback to ensure a user-friendly experience.
  • Spearheaded the development of core functionalities essential for a mobile application, including user authentication, notification system, and location-based features.
  • Implemented a robust CI/CD pipeline for automated testing and streamlined deployment across environments.
  • Leveraging my skills, I also developed mobile app functionalities for a US-based client (location-based event-sharing app) during my time at Shaw and Partners.""",
              startDate: DateTime(2022, 07),
              isAtual: true,
            ),
            ProfessionalExperience(
              company: 'Vizo',
              context: 'Software Development Company',
              position: 'Flutter Developer',
              startDate: DateTime(2022, 07),
              endDate: DateTime(2022, 12),
              isAtual: true,
              responsability:
                  """Developed a cross-platform mobile application using Flutter (iOS, Android) for a confidential project in the government sector.
  • Leveraged Flutter Flavors to manage distinct environments for various city halls, including: individual databases, custom theme/icons, app name, assets and unique bundle names for separate Play Store and App Store listings.
  • Designed and implemented user-friendly interfaces for managing city halls operations.

Developed a cross-platform mobile application using Flutter (iOS, Android, Web) called Colored Food. This app caters to the Health & Wellness industry by providing a dietary management tool.
  • Designed and implemented user-friendly interfaces suitable for managing hotel reservations.
  • Enabled offline functionality for the app, ensuring users can access essential features even without an internet connection.
  • Implemented a secure authentication system using Firebase OAuth.
  • Integrated accessibility features to ensure the app is inclusive for users with disabilities.
  • Demonstrated strong collaboration and project management skills, effectively working within a team environment""",
            ),
          ],
          courses: [],
          userUID: 'userUID',
        ),
      ),
    );
  }
}
