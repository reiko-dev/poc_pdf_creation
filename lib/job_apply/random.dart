import 'dart:math';

import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:faker/faker.dart' as f;
import 'package:flutter/material.dart';
import 'package:poc_pdf_creation/curriculum/index.dart';
import 'package:poc_pdf_creation/job_apply/company.dart';
import 'package:poc_pdf_creation/job_apply/job.dart';
import 'package:poc_pdf_creation/job_apply/job_name.dart';
import 'package:poc_pdf_creation/job_apply/manager.dart';
import 'package:poc_pdf_creation/job_apply/user.dart';
import 'package:poc_pdf_creation/models/index.dart';

class Fake {
  static final _rand = Random();
  static final cnpjValidator = CNPJValidator();

  static final faker = f.Faker();

  static bool get boolean => _rand.nextBool();

  static int integer({int initial = 0, int itens = 20}) =>
      initial + _rand.nextInt(itens);

  static double decimal([int maxValue = 1]) => _rand.nextDouble() * maxValue;

  static String get customUid => faker.guid.guid();
  static String get email => faker.internet.email();
  static String get fone => faker.phoneNumber.us();
  static String get name => faker.person.name();
  static String lorem(int maxWords) =>
      faker.lorem.words(1 + _rand.nextInt(maxWords - 1)).join(' ');

  static String loremSentences(int maxSentences) => faker.lorem
      .sentences(1 + _rand.nextInt(max(1, maxSentences - 1)))
      .join(' ');

  static String get cnpj => CNPJValidator.generate(true);

  static String get cpf => CNPJValidator.generate(false);

  static String get site => faker.internet.domainName();

  static User createFakeUser([String? uid]) {
    final now = DateTime.now();
    return CommonUser(
      uid: customUid,
      email: email,
      createdAt: now,
      updatedAt: now,
      name: name,
      cpf: cpf,
    );
  }

  static Company createFakeCompany([String? uid]) {
    final now = DateTime.now();
    return Company(
      uid: uid ?? Fake.customUid,
      socialReason: Fake.lorem(3),
      emails: ['fake@mail.com'],
      isEmailVerified: Fake.boolean,
      name: Fake.lorem(3),
      isActive: true,
      managers: [],
      activityContext: Fake.lorem(5),
      cnpj: Fake.cnpj,
      cellphone: Fake.integer(initial: 10000000000, itens: 10000000).toString(),
      createdAt: now,
      updatedAt: now,
      phone2: Fake.integer(initial: 10000000000, itens: 10000000).toString(),
      applyProfiler: Fake.boolean,
      address: createFakeAddress(),
      applyPsichologicalEvaluation: Fake.boolean,
      observations: Fake.loremSentences(5),
      site: Fake.site,
      cancellationPenalty: Fake.decimal(),
      contractDate: now,
      contractPercentage: Fake.decimal(50),
      profilerValue: Fake.decimal(300),
      psychologicalEvaluationValue: Fake.decimal(200),
    );
  }

  static Address createFakeAddress({String? uid}) {
    return Address(
      cep: Fake.faker.address.zipCode(),
      address: Fake.loremSentences(1),
      addressNumber: Fake.integer(itens: 20000),
      neighborhood: Fake.lorem(3),
      complement: Fake.loremSentences(3),
      city: Fake.lorem(2),
      state: BrazilState
          .values[Fake.integer(itens: BrazilState.values.length)].name,
    );
  }

  static Manager createFakeManager({String? uid}) {
    return Manager(
      uid: uid ?? Fake.customUid,
      name: Fake.name,
      email: Fake.email,
      phone2: Fake.fone,
      phone: Fake.fone,
    );
  }

  static Job createFakeJob({
    required Company company,
    required JobName job,
    String? uid,
  }) {
    return Job(
      uid: uid ?? Fake.customUid,
      jobName: Fake.lorem(2),
      company: company,
      job: job,
      qtd: Fake.faker.randomGenerator.integer(4, min: 1),
      salary: Fake.faker.randomGenerator.integer(10000, min: 2000).toDouble(),
      showSalary: Fake.boolean,
      isActive: true,
      description: Fake.loremSentences(8),
      createdAt: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      jobApplies: [],
      city: Fake.fakeCity,
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
    );
  }

  static JobName createFakeJobName({String? uid}) {
    return JobName(
      uid: uid ?? Fake.customUid,
      title: Fake.lorem(4),
      isActive: Fake.boolean,
    );
  }

  static String fakeCity = Fake.faker.address.city();
}
