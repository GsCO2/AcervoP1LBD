package persistence;

import java.sql.SQLException;

public interface ICrudExcDao<T> {
	/*
	 ISP -> Principio de segregação de interfaces, o aluno não pode ser excluído
	 do db, logo apenas o exemplar assina essa interface, segregando apenas as funções necessárias
	 */
	public String excluir(T t) throws SQLException, ClassNotFoundException;
}
