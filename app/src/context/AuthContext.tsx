import {
  createContext,
  PropsWithChildren,
  useContext,
  useEffect,
  useState,
} from "react";
import { supabase } from "@/utils/supabase";

type AuthContextType = { isLoggedIn: boolean };
const AuthContext = createContext<AuthContextType>({ isLoggedIn: false });

export const AuthContextProvider = ({ children }: PropsWithChildren) => {
  const [userId, setUserId] = useState<string>();

  const handleAuthStateChange: Parameters<
    typeof supabase.auth.onAuthStateChange
  >[0] = async (_, session) => {
    setUserId(session?.user.id);
  };

  useEffect(() => {
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(handleAuthStateChange);

    return () => {
      subscription.unsubscribe();
    };
  }, []);

  return <AuthContext value={{ isLoggedIn: !!userId }}>{children}</AuthContext>;
};

export const useAuthContext = () => useContext(AuthContext);
