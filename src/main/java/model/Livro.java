package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class Livro extends Exemplar {
	private String ISBN;
	private int edicao;
	
	@Override
	public String getDoc() {
	    return ISBN;
	}
	@Override
	public Integer getEdicao() {
        return edicao;
    }
}

