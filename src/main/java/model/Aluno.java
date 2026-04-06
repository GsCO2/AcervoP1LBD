package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Aluno {
	private String cpf;
	private String nome;
	private String senha;
	private String ra;
	private String email;
}
