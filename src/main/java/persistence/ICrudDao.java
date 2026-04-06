package persistence;

import java.sql.SQLException;
import java.util.List;

public interface ICrudDao<T> {
	public String inserir (T t) throws SQLException, ClassNotFoundException;
	public String alterar (T t) throws SQLException, ClassNotFoundException;
	public T buscar(T t) throws SQLException, ClassNotFoundException;
	public List<T> listar() throws SQLException, ClassNotFoundException;
}
