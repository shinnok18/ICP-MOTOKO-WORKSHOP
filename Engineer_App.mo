import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Option "mo:base/Option";

//EngineerApp

actor {
  type EngineerId = Nat32;

  type Engineer ={
    name :Text;
    surname :Text;
    department :Text;
    phone: Text;
    email :Text;
    isFavorite : Bool;
    isWorked : Bool;
  };


  type ResponseEngineer = {
    name :Text;
    surname :Text;
    department :Text;
    phone: Text;
    email :Text;
    isFavorite : Bool;
    isWorked : Bool;
    id: Nat32;
  };


  private stable var next :EngineerId = 0;
 
  private stable var engineers : Trie.Trie<EngineerId, Engineer> = Trie.empty();

  
  private func key(x:EngineerId) : Trie.Key<EngineerId> {
    return {hash= x; key = x};
  };


  private func validatePhoneNumber(phone: Text): Bool {
    if (phone.size() != 10) {
      return false;
    };
    return true;
  };


  public func addEngineer(engineer: Engineer) : async Text {
    if (not validatePhoneNumber(engineer.phone)) {
      return "Phone number must be 10 digits";
    };
    let engineerId  = next;
    next +=1;

    engineers := Trie.replace(
      engineers,
      key(engineerId),
      Nat32.equal,
      ?engineer,
    ).0;
    return ("Engineer is created successfully");
  };

  public func getEngineers() : async [ResponseEngineer] {
    return Trie.toArray<EngineerId,Engineer,ResponseEngineer>(
      engineers,
      func (k,v) {
        {id=k;name=v.name;surname=v.surname;department=v.department;phone=v.phone;email=v.email;isFavorite=v.isFavorite;isWorked=v.isWorked}
      }
    );
  };

  public func updateEngineer(EngineerId:EngineerId,engineer:Engineer) : async Bool{
    let result = Trie.find(engineers, key(EngineerId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      engineers := Trie.replace(
        engineers,
        key(EngineerId),
        Nat32.equal,
        ?engineer,
      ).0;
    };

    return exists;
  };

  public func deleteEngineer(engineerId:EngineerId) : async Bool {
    let result = Trie.find(engineers, key(engineerId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      engineers := Trie.replace(
        engineers,
        key(engineerId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

};
