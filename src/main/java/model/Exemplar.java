package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
/*
 LSP Principio de Substituição de Liskov, design da classe pensado 
 em seguir o LSP, os filhos podem substiotuir o pai sem prujuízo.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public abstract class Exemplar {
	private int codigo;
	private String nome;
	private int qtdPag;
	
	public abstract String getDoc();
	
	public Integer getEdicao() {
        return null;
    }
}
