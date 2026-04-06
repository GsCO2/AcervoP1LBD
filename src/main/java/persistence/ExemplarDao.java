package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Exemplar;
import model.Livro;
import model.Revista;
/*
 SRP -> Principio da Responsabilidade Unica, o exemplar DAO só lida com
 os comandos advindos do exemplar, e como pode ser excluido assina a 
 interface de exclusão.
 */
public class ExemplarDao implements ICrudDao<Exemplar>, ICrudExcDao<Exemplar> {

	GenericDao gDao;

	public ExemplarDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String excluir(Exemplar e) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "{CALL sp_Ger_exemplar(?,?,?,?,?,?,?)}";
		CallableStatement cs = con.prepareCall(sql);
		cs.setString(1, "D");
		cs.setInt(2, e.getCodigo());
		cs.setNull(3, Types.VARCHAR);
		cs.setNull(4, Types.VARCHAR);
		cs.setNull(5, Types.VARCHAR);
		cs.setNull(6, Types.VARCHAR);
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(7);
		cs.close();
		con.close();
		return saida;
	}

	@Override
	public String inserir(Exemplar e) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "{CALL sp_Ger_exemplar(?,?,?,?,?,?,?)}";
		CallableStatement cs = con.prepareCall(sql);
		cs.setString(1, "I");
		cs.setNull(2, Types.VARCHAR);
		cs.setString(3, e.getNome());
		if(e instanceof Livro) {
			Livro l = (Livro) e;
			cs.setString(4, l.getISBN());
			cs.setInt(6, l.getEdicao());
		} else {
			Revista revista = (Revista) e;
	        cs.setString(4, revista.getISSN());
	        cs.setNull(6, Types.VARCHAR);
		}
		cs.setInt(5, e.getQtdPag());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(7);
		cs.close();
		con.close();
		return saida;
	}

	@Override
	public String alterar(Exemplar e) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "{CALL sp_Ger_exemplar(?,?,?,?,?,?,?)}";
		CallableStatement cs = con.prepareCall(sql);
		cs.setString(1, "U");
		cs.setInt(2, e.getCodigo());
		cs.setString(3, e.getNome());
		if(e instanceof Livro) {
			Livro l = (Livro) e;
			cs.setNull(4, Types.VARCHAR);
			cs.setInt(6, l.getEdicao());
		} else {
	        cs.setNull(4, Types.VARCHAR);
	        cs.setNull(6, Types.VARCHAR);
		}
		cs.setInt(5, e.getQtdPag());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(7);
		cs.close();
		con.close();
		return saida;
	}

	@Override
	public Exemplar buscar(Exemplar e) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "SELECT codigo, nome, qtdPag, tipo, ISBN_ISSN, edicao  FROM selectGeral WHERE codigo = ?";
		PreparedStatement ps = con.prepareStatement(sql);
	    ps.setInt(1, e.getCodigo());
	    ResultSet rs = ps.executeQuery();
	    if(rs.next()) {
	    	String tipo = rs.getString("tipo");
	    	if(tipo.equalsIgnoreCase("Livro")) {
	    		Livro l = new Livro();
	    		l.setCodigo(rs.getInt("codigo"));
	    		l.setNome(rs.getString("nome"));
	    		l.setQtdPag(rs.getInt("qtdPag"));
	    		l.setISBN(rs.getString("ISBN_ISSN"));
	    		l.setEdicao(rs.getInt("edicao"));
	    		rs.close();
	    		ps.close();
	    		con.close();
	    		return l;
	    	} else if(tipo.equalsIgnoreCase("Revista")) {
	    		Revista r = new Revista();
	    		r.setCodigo(rs.getInt("codigo"));
	    		r.setNome(rs.getString("nome"));
	    		r.setQtdPag(rs.getInt("qtdPag"));
	    		r.setISSN(rs.getString("ISBN_ISSN"));
	    		rs.close();
	    		ps.close();
	    		con.close();
	    		return r;
	    	}
	    }
	    rs.close();
	    ps.close();
	    con.close();
		return null;
	}

	@Override
	public List<Exemplar> listar() throws SQLException, ClassNotFoundException {
		List<Exemplar> e = new ArrayList<>();
		Connection con = gDao.getConnection();
		String sql = "SELECT codigo, nome, qtdPag, tipo, ISBN_ISSN, edicao  FROM selectGeral";
		PreparedStatement ps = con.prepareStatement(sql);
	    ResultSet rs = ps.executeQuery();
	    while(rs.next()) {
	    	String tipo = rs.getString("tipo");
	    	if(tipo.equalsIgnoreCase("Livro")) {
	    		Livro l = new Livro();
	    		l.setCodigo(rs.getInt("codigo"));
	    		l.setNome(rs.getString("nome"));
	    		l.setQtdPag(rs.getInt("qtdPag"));
	    		l.setISBN(rs.getString("ISBN_ISSN"));
	    		l.setEdicao(rs.getInt("edicao"));
	    		e.add(l);
	    	} else if(tipo.equalsIgnoreCase("Revista")) {
	    		Revista r = new Revista();
	    		r.setCodigo(rs.getInt("codigo"));
	    		r.setNome(rs.getString("nome"));
	    		r.setQtdPag(rs.getInt("qtdPag"));
	    		String issn = (rs.getString("ISBN_ISSN"));
	    		r.setISSN(issn.trim());
	    		e.add(r);
	    	}
	    }
	    rs.close();
	    ps.close();
	    con.close();
	    return e;
	} 
}
