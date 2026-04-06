package persistence;

import java.sql.SQLException;

import model.Aluno;

public interface ICrudSession<T> {
	/*
	 ISP -> Principio de segregação de interfaces, o aluno precisa ser autenticado para ver
	 a lista de exemplares, logo apenas o aluno assina essa interface, segregando apenas 
	 as funções necessárias.
	 */
	public Aluno login(T t)throws SQLException, ClassNotFoundException;
}
