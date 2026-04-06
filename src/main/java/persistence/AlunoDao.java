package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Aluno;
/*
 SRP -> Principio da Responsabilidade Unica, o aluno DAO só lida com
 os comandos advindos do aluno.
 ISP -> Principio de Segregação de Interfaces, ICrudDao e ICRUDSession,
 caso não houvesse necessidade de criar sessão é só remover a session.
 */
public class AlunoDao implements ICrudDao<Aluno>, ICrudSession<Aluno> {
	
	GenericDao gDao;
	
	public AlunoDao(GenericDao gDao) {
		this.gDao = gDao;
	}
	
	@Override
	public String inserir(Aluno a) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "{CALL sp_Ger_aluno(?,?,?,?,?)}";
		CallableStatement cs = con.prepareCall(sql);
		cs.setString(1, "I");
		cs.setString(2, a.getNome());
		cs.setString(3, a.getCpf());
		cs.setString(4, a.getSenha());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(5);
		cs.close();
		con.close();
		return saida;
	}

	@Override
	public String alterar(Aluno a) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "{CALL sp_Ger_aluno(?,?,?,?,?)}";
		CallableStatement cs = con.prepareCall(sql);
		cs.setString(1, "U");
		cs.setNull(2, Types.VARCHAR);
		cs.setString(3, a.getCpf());
		cs.setString(4, a.getSenha());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(5);
		cs.close();
		con.close();
		return saida;
	}

	@Override
	public Aluno buscar(Aluno a) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "SELECT cpf, nome, senha, ra, email FROM aluno WHERE cpf = ?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString (1,a.getCpf());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			a.setNome(rs.getString("nome"));
			a.setSenha(rs.getString("senha"));
			a.setRa(rs.getString("ra"));
			a.setEmail(rs.getString("email"));
		}
		rs.close();
		ps.close();
		con.close();
		return a;
	}

	@Override
	public List<Aluno> listar() throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		List<Aluno> alunos = new ArrayList<>();
		String sql = "SELECT cpf, nome, senha, ra, email FROM aluno";
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Aluno a = new Aluno();
			a.setCpf(rs.getString("cpf"));
			a.setNome(rs.getString("nome"));
			a.setSenha(rs.getString("senha"));
			a.setRa(rs.getString("ra"));
			a.setEmail(rs.getString("email"));
			alunos.add(a);
		}
		rs.close();
		ps.close();
		con.close();
		return alunos;
	}

	@Override
	public Aluno login(Aluno a) throws SQLException, ClassNotFoundException {
		Connection con = gDao.getConnection();
		String sql = "SELECT cpf, nome, senha, ra, email FROM aluno WHERE email = ? and senha = ?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString (1,a.getEmail());
		ps.setString (2,a.getSenha());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			a.setCpf(rs.getString("cpf"));
			a.setNome(rs.getString("nome"));
			a.setSenha(rs.getString("senha"));
			a.setRa(rs.getString("ra"));
			a.setEmail(rs.getString("email"));
			rs.close();
			ps.close();
			con.close();
			return a;
		}
		rs.close();
		ps.close();
		con.close();
		return null;
	}

}
