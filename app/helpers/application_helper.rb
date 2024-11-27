module ApplicationHelper
  def invitation_status_class(status)
    case status
    when 'accepted'
      'text-success'
    when 'declined'
      'text-danger'
    else
      'text-warning'
    end
  end

  def invitation_status_text(status)
    case status
    when 'accepted'
      'Accettato'
    when 'declined'
      'Rifiutato'
    else
      'Non Risposto'
    end
  end
end
