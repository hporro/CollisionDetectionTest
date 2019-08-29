class Stack<T>{
  ArrayList<T> elements;
  Stack(){
    elements = new ArrayList<T>();
  }
  void push(T e){
    elements.add(e);
  }
  T pop(){
    T res = elements.get(elements.size()-1);
    elements.remove(elements.size()-1);
    return res;
  }
  boolean isEmpty(){
    return elements.isEmpty();
  }
}
