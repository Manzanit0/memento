defmodule MementoContactsTest do
  use Memento.DataCase

  alias Memento.Contacts
  alias Memento.Contacts.Contact

  setup do
    {:ok, contact} = Contacts.save(%{full_name: "Javier", birthdate: ~D[1993-01-01]})
    %{contact: contact}
  end

  test "creation of a contact" do
    {:ok, contact} = Contacts.save(%{full_name: "Javier"})
    assert %Contact{full_name: "Javier", birthdate: nil} = contact
  end

  test "update of a contact", %{contact: contact} do
    {:ok, contact} = Contacts.save(contact, %{birthdate: ~D[2000-01-01]})
    assert %Contact{full_name: "Javier", birthdate: ~D[2000-01-01]} = contact
  end

  test "find a contact by name" do
    {:ok, _} = Contacts.save(%{full_name: "fiddly-doo", birthdate: ~D[2000-01-01]})

    assert %Contact{full_name: "fiddly-doo", birthdate: ~D[2000-01-01]} =
             Contacts.find_by_name("fiddly-doo")
  end

  test "delete a contact", %{contact: contact} do
    {:ok, _} = Contacts.delete(contact)
    assert [] == Contacts.all()
  end
end
