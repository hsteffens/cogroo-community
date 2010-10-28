package br.usp.ime.cogroo.logic;

import br.com.caelum.vraptor.ioc.Component;
import br.usp.ime.cogroo.dao.UserDAO;
import br.usp.ime.cogroo.dao.errorreport.ErrorEntryDAO;

/**
 * 
 * @author Michel
 */
@Component
public class Stats {

	private UserDAO userDAO;
	private ErrorEntryDAO errorEntryDAO;

	private int totalMembers = -1;
	private int onlineMembers = -1;
	private int reportedErrors = -1;

	public Stats(UserDAO userDAO, ErrorEntryDAO errorEntryDAO) {
		this.userDAO = userDAO;
		this.errorEntryDAO = errorEntryDAO;
	}

	public int getTotalMembers() {
		// TODO Pode ser ineficiente. Usar AplicationScoped?
		return (int) userDAO.count();
	}

	public int getOnlineMembers() {
		return (int) userDAO.countLogged();
	}

	public int getReportedErrors() {
		return (int) errorEntryDAO.count();
	}

}