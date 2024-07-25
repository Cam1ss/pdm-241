import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('alunos.db');

  // Criar a tabela TB_ALUNO se não existir
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  while (true) {
    print('Escolha uma opção:');
    print('1 - Adicionar Aluno');
    print('2 - Listar Alunos');
    print('3 - Sair');

    final choice = stdin.readLineSync();

    if (choice == '1') {
      addAluno(db);
    } else if (choice == '2') {
      listAlunos(db);
    } else if (choice == '3') {
      break;
    } else {
      print('Opção inválida, tente novamente.');
    }
  }

  db.dispose();
}

void addAluno(Database db) {
  print('Digite o nome do aluno:');
  final nome = stdin.readLineSync()!.trim();

  if (nome.isNotEmpty && nome.length <= 50) {
    final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
    stmt.execute([nome]);
    stmt.dispose();
    print('Aluno adicionado com sucesso.');
  } else {
    print('Nome inválido. O nome deve ter até 50 caracteres.');
  }
}

void listAlunos(Database db) {
  final result = db.select('SELECT id, nome FROM TB_ALUNO');

  if (result.isNotEmpty) {
    print('ID\tNome');
    for (final row in result) {
      print('${row['id']}\t${row['nome']}');
    }
  } else {
    print('Nenhum aluno encontrado.');
  }
}
